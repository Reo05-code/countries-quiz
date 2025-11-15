class Country < ApplicationRecord
  # 国が削除された場合、関連する履歴や獲得情報も削除
  has_many :quiz_attempts, dependent: :destroy
  has_many :user_flags, dependent: :destroy
  has_many :users, through: :user_flags

  # 国名は必須かつ一意
  validates :name, presence: true, uniqueness: true

  # 4つのヒントと国旗URLは必須
  validates :hint_1, presence: true
  validates :hint_2, presence: true
  validates :hint_3, presence: true
  validates :hint_4, presence: true
  validates :flag_url, presence: true
end
