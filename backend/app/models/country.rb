class Country < ApplicationRecord
  # 国が削除された場合、関連する履歴や獲得情報も削除
  has_many :quiz_attempts, dependent: :destroy
  has_many :user_flags, dependent: :destroy
  has_many :users, through: :user_flags

  # 国名と読み仮名は必須かつ一意
  validates :name, presence: true, uniqueness: true
  validates :reading, presence: true

  # 4つのヒントと国旗URLは必須
  validates :hint_1, :hint_2, :hint_3, :hint_4, :flag_url, presence: true
end
