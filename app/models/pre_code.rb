# app/models/pre_code.rb
class PreCode < ApplicationRecord
  belongs_to :user
  has_many :likes,      dependent: :destroy
  has_many :used_codes, dependent: :destroy

  validates :title,
            presence: true,
            length: { maximum: 50 },
            format: { without: /\A\s*\z/, message: "を空白だけにはできません" }

  validates :description, length: { maximum: 2000 }, allow_blank: true
  validates :body, presence: true

  # === 一覧・並び替え向けスコープ ===
  scope :except_user, ->(uid) { uid.present? ? where.not(user_id: uid) : all }
  scope :popular,     ->       { order(like_count: :desc, id: :desc) }
  scope :most_used,   ->       { order(use_count: :desc,  id: :desc) }

  # === Ransack 4 (Rails 7+) 許可リスト ===
  def self.ransackable_attributes(_auth = nil)
    %w[title description like_count use_count created_at user_id]
  end

  def self.ransackable_associations(_auth = nil)
    %w[user]
  end
end
