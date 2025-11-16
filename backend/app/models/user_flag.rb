class UserFlag < ApplicationRecord
  belongs_to :user
  belongs_to :country

  # 1ユーザーが同じ国を重複して獲得できないようにする
  validates :user_id, uniqueness: { scope: :country_id, message: "はすでにこの国旗を獲得済みです" }
end
