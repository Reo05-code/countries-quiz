require 'rails_helper'

RSpec.describe QuizAttempt, type: :model do

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:country) }
  end

  describe 'validations' do
    # subject はこの describe ブロック内でのみ有効
    subject { build(:quiz_attempt) }

    it { should validate_inclusion_of(:correct).in_array([true, false]) }
    it { should validate_presence_of(:hint_level) }
    it { should validate_inclusion_of(:hint_level).in_range(1..4) }
  end

  describe 'factory' do
    it '有効なファクトリを持つこと' do
      # build(:quiz_attempt) がバリデーションを通過することを確認
      expect(build(:quiz_attempt)).to be_valid
    end
  end

  describe '仕様に関するテスト' do
  it '有効な属性でクイズ挑戦を作成できること' do
    attempt = create(:quiz_attempt, correct: true, hint_level: 2)
    expect(attempt).to be_valid
    expect(attempt.correct).to be true
    expect(attempt.hint_level).to eq(2)
  end

  it 'correctがnilの場合は作成できないこと' do
    attempt = build(:quiz_attempt, correct: nil)
    expect(attempt).not_to be_valid
  end

  it 'hint_levelが0の場合は作成できないこと' do
    attempt = build(:quiz_attempt, hint_level: 0)
    expect(attempt).not_to be_valid
  end

  it 'hint_levelが5の場合は作成できないこと' do
    attempt = build(:quiz_attempt, hint_level: 5)
    expect(attempt).not_to be_valid
  end

  it '同じユーザーが同じ国に複数回挑戦できること' do
    user = create(:user)
    country = create(:country)

    attempt1 = create(:quiz_attempt, user: user, country: country, correct: false)
    attempt2 = create(:quiz_attempt, user: user, country: country, correct: true)

    expect(attempt1).to be_valid
    expect(attempt2).to be_valid
    expect(user.quiz_attempts.count).to eq(2)
  end
end


end
