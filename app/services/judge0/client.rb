# app/services/judge0/client.rb
# 役割:
# - Judge0 への submit / fetch を HTTParty で薄くラップ
# - MVP 用に短いポーリング run_* を提供（Ruby は lang_id 72）
# - 例外時は Judge0::Error を投げて上位で rescue しやすく

module Judge0
  class Error < StandardError; end

  class Client
    include HTTParty
    format :json
    # 低レベルのタイムアウト（秒）
    default_timeout 10

    RUBY_LANG_ID = 72 # Judge0 の Ruby (2.7) 系 ID。環境により変わる場合あり

    def initialize
      cfg = Rails.configuration.x.judge0 || {}
      @base = cfg[:base_url].to_s
      raise Error, "Judge0 base_url is not set" if @base.blank?

      @headers = { "Content-Type" => "application/json" }
      if (k = cfg[:api_key]).present?
        @headers["X-RapidAPI-Key"]  = k
        @headers["X-RapidAPI-Host"] = cfg[:host_hdr] if cfg[:host_hdr].present?
      end
    end

    # 提出: 非同期(wait=false)。戻り値: HTTParty::Response
    def submit(source_code:, language_id: RUBY_LANG_ID, stdin: nil)
      body = { source_code:, language_id: }
      body[:stdin] = stdin if stdin
      self.class.post(
        "#{@base}/submissions?base64_encoded=false&wait=false",
        headers: @headers, body: body.to_json
      ).tap { |res| raise_if_bad(res) }
    end

    # 取得: トークンで結果取得
    def fetch(token)
      self.class.get(
        "#{@base}/submissions/#{token}?base64_encoded=false",
        headers: @headers
      ).tap { |res| raise_if_bad(res) }
    end

    # Ruby コードを投げて最終結果(JSON)を返す
    # max_wait: 最大待機秒、interval: ポーリング間隔秒
    def run_ruby(code, language_id: RUBY_LANG_ID, max_wait: 5.0, interval: 0.4)
      token = submit(source_code: code, language_id: language_id).parsed_response["token"]
      raise Error, "submit returns no token" if token.blank?

      waited = 0.0
      loop do
        res = fetch(token).parsed_response
        status_id = res.dig("status", "id")
        # 1: In Queue, 2: Processing, 3 以上が終了系（3: Accepted, 6: Compilation error, など）
        return res if status_id && status_id >= 3

        sleep interval
        waited += interval
        break if waited >= max_wait
      end

      { "status" => { "id" => -1, "description" => "Timeout" } }
    end

    private

    def raise_if_bad(res)
      # ネットワーク、4xx/5xx を 例外に
      unless res.code && res.code.between?(200, 299)
        detail = res.parsed_response.is_a?(Hash) ? res.parsed_response : res.body
        raise Error, "Judge0 HTTP #{res.code}: #{detail}"
      end
      res
    end
  end
end
