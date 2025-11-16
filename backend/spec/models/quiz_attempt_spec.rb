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

end
