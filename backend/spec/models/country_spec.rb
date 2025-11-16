require "rails_helper"

RSpec.describe Country do
  describe "associations" do
    it { is_expected.to have_many(:quiz_attempts).dependent(:destroy) }
    it { is_expected.to have_many(:user_flags).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_flags) }
  end

  describe "validations" do
    # createでDB保存を伴うためvalidationを検証できる
    subject { create(:country) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:hint_1) }
    it { is_expected.to validate_presence_of(:hint_2) }
    it { is_expected.to validate_presence_of(:hint_3) }
    it { is_expected.to validate_presence_of(:hint_4) }
    it { is_expected.to validate_presence_of(:flag_url) }
  end

  describe "factory" do
    it "有効なファクトリを持つこと" do
      expect(build(:country)).to be_valid
    end
  end
end
