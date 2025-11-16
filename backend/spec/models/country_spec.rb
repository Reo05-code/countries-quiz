require 'rails_helper'

RSpec.describe Country, type: :model do
  describe 'associations' do
    it { should have_many(:quiz_attempts).dependent(:destroy) }
    it { should have_many(:user_flags).dependent(:destroy) }
    it { should have_many(:users).through(:user_flags) }
  end

  describe 'validations' do
    #createでDB保存を伴うためvalidationを検証できる
    subject { create(:country) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:hint_1) }
    it { should validate_presence_of(:hint_2) }
    it { should validate_presence_of(:hint_3) }
    it { should validate_presence_of(:hint_4) }
    it { should validate_presence_of(:flag_url) }
  end

  describe 'factory' do
    it '有効なファクトリを持つこと' do
      expect(build(:country)).to be_valid
    end
  end
end
