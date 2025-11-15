class QuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :country

  # 正解/不正解（true/false）のどちらかであることを必須にする
  validates :correct, inclusion: { in: [true, false] }

  # ヒントレベルが 1〜4 の範囲内であることを保証する
  validates :hint_level, presence: true, inclusion: { in: 1..4 }
end
