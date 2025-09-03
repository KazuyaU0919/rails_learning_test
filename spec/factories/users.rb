# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password              { "secret123" }
    password_confirmation { "secret123" }
    admin { false }
  end

  # ===== OAuth（Google）=====
  factory :google_user, parent: :user do
    # 「password不要」
    password              { nil }
    password_confirmation { nil }

    # build 段階で「OAuth判定」に入るよう provider/uid を直接付与（カラムがあれば）
    after(:build) do |user|
      if user.respond_to?(:provider)
        user.provider ||= "google_oauth2"
        user.uid      ||= "uid-#{SecureRandom.hex(4)}"
      end

      # has_many :authentications を使うアプリ向け（関連があれば in-memory でも追加）
      if user.respond_to?(:authentications)
        user.authentications.build(
          provider: "google_oauth2",
          uid:      "uid-#{SecureRandom.hex(4)}"
        )
      end
    end

    # create 時には関連を永続化（exists? を使う実装でも確実に OAuth 判定になる）
    after(:create) do |user|
      if user.respond_to?(:authentications) && !user.authentications.exists?
        user.authentications.create!(
          provider: "google_oauth2",
          uid:      "uid-#{SecureRandom.hex(4)}"
        )
      end
    end
  end

  # ===== OAuth（GitHub, admin: true）=====
  factory :github_user, parent: :user do
    admin { true }
    password              { nil }
    password_confirmation { nil }

    after(:build) do |user|
      if user.respond_to?(:provider)
        user.provider ||= "github"
        user.uid      ||= "uid-#{SecureRandom.hex(4)}"
      end

      if user.respond_to?(:authentications)
        user.authentications.build(
          provider: "github",
          uid:      "uid-#{SecureRandom.hex(4)}"
        )
      end
    end

    after(:create) do |user|
      if user.respond_to?(:authentications) && !user.authentications.exists?
        user.authentications.create!(
          provider: "github",
          uid:      "uid-#{SecureRandom.hex(4)}"
        )
      end
    end
  end
end
