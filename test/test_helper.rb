# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "omniauth"
OmniAuth.config.test_mode = true

module OmniAuthTestHelper
  # 使うたびにモック差し替え
  def mock_omniauth(provider:, uid: "u-123", name: "Mock User", email: "mock@example.com")
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: uid,
      info: { name: name, email: email }
    )
  end
end

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
  fixtures :all
  include OmniAuthTestHelper

  # 各テストの後始末（モックをクリア）
  teardown do
    OmniAuth.config.mock_auth.clear
  end
end
