# lib/tasks/users.rake
namespace :users do
  desc "同一メールの重複ユーザーを1つに統合（DRY RUN。適用したいときは EXECUTE=1 を付ける）"
  task merge_duplicates: :environment do
    dry = ENV["EXECUTE"] != "1"
    log = ->(msg) { puts msg }

    # lower(email) でグルーピングし、2件以上あるメールのみ対象
    emails = User.group("lower(email)").having("count(*) > 1")
                 .pluck(Arel.sql("lower(email)"))

    emails.each do |email_lc|
      User.transaction do
        users = User.lock.where("lower(email) = ?", email_lc).order(:id) # 古い順に
        keep  = users.first
        dups  = users.offset(1)

        log.call "[#{email_lc}] keep=#{keep.id}, duplicates=#{dups.size}"

        dups.find_each do |dupe|
          # --- 1) pre_codes（重複心配なし）そのまま移行 ---
          if dry
            log.call "  would move pre_codes(#{dupe.pre_codes.count}) user_id: #{dupe.id} -> #{keep.id}"
          else
            dupe.pre_codes.update_all(user_id: keep.id)
          end

          # --- 2) likes（user_id, pre_code_id の一意制約がある）重複を捨てながら移行 ★ ---
          dupe.likes.find_each do |like|
            if Like.exists?(user_id: keep.id, pre_code_id: like.pre_code_id)
              if dry
                log.call "  would drop duplicate like pre_code_id=#{like.pre_code_id} (user #{keep.id} already has it)"
              else
                like.destroy!  # 片方だけ残す（keep 側を優先）
              end
            else
              if dry
                log.call "  would move like #{like.id} -> keep"
              else
                like.update!(user_id: keep.id)
              end
            end
          end

          # --- 3) used_codes も同様の重複があればケア ★（unique がある場合） ---
          # もし used_codes に [:user_id, :pre_code_id] の unique があるなら下を有効化
          dupe.used_codes.find_each do |uc|
            if UsedCode.exists?(user_id: keep.id, pre_code_id: uc.pre_code_id)
              if dry
                log.call "  would drop duplicate used_code pre_code_id=#{uc.pre_code_id} (already at keep)"
              else
                uc.destroy!
              end
            else
              if dry
                log.call "  would move used_code #{uc.id} -> keep"
              else
                uc.update!(user_id: keep.id)
              end
            end
          end

          # --- 4) authentications（provider,uid 一意）衝突回避は現状のままでOK ---
          dupe.authentications.find_each do |a|
            if keep.authentications.exists?(provider: a.provider, uid: a.uid)
              dry ? log.call("  skip auth #{a.provider}/#{a.uid} (already on keep)") : a.destroy!
            else
              dry ? log.call("  would move auth #{a.provider}/#{a.uid} -> keep") : a.update!(user_id: keep.id)
            end
          end

          # --- 5) admin の昇格 & dupe 削除（あなたの元コード通りでOK） ---
          if dupe.admin? && !keep.admin?
            dry ? log.call("  would promote keep(#{keep.id}) to admin") : keep.update!(admin: true)
          end
          dry ? log.call("  would destroy user #{dupe.id}") : dupe.destroy!
        end
      end
    end

    log.call dry ? "DRY RUN 完了（EXECUTE=1 で適用）" : "統合作業 完了"
  end
end
