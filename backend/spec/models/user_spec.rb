require "rails_helper"

RSpec.describe User do
  # バリデーション (Validations) のテスト
  describe "validations" do
    # :name が必須であること
    it { is_expected.to validate_presence_of(:name) }

    # :name が 50 文字以下であること
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end

  # 関連付け (Associations) のテスト
  describe "associations" do
    # quiz_attempts と 1:N の関係 (has_many) があり、
    # User 削除時に quiz_attempts も削除 (dependent: :destroy) されること
    it { is_expected.to have_many(:quiz_attempts).dependent(:destroy) }

    # user_flags と 1:N の関係 (has_many) があり、
    # User 削除時に user_flags も削除 (dependent: :destroy) されること
    it { is_expected.to have_many(:user_flags).dependent(:destroy) }

    # user_flags を通じて countries と N:N の関係 (has_many :through) があること
    it { is_expected.to have_many(:countries).through(:user_flags) }
  end

  describe "データ作成" do
    it "有効な属性でユーザーを作成できること" do
      user = described_class.create(name: "テストユーザー", email: "test@example.com")
      expect(user).to be_valid
      expect(user.name).to eq("テストユーザー")
    end

    it "名前なしでは作成できないこと" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it "名前が51文字以上の場合は作成できないこと" do
      user = build(:user, name: "a" * 51)
      expect(user).not_to be_valid
    end
  end

  describe "factory" do
    it "有効なファクトリを持つこと" do
      expect(build(:user)).to be_valid
    end
  end
end
