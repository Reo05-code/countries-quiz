class User < ApplicationRecord
  has_many :quiz_attempts, dependent: :destroy
  has_many :user_flags, dependent: :destroy 
  has_many :countries, through: :user_flags

  # ユーザー名は必須
  validates :name, presence: true, length: { maximum: 50 }
end
