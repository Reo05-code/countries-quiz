require 'rails_helper'

RSpec.describe User, type: :model do

  # バリデーション (Validations) のテスト
  describe 'validations' do
    # :name が必須であること
    it { should validate_presence_of(:name) }

    # :name が 50 文字以下であること
    it { should validate_length_of(:name).is_at_most(50) }
  end

  # 関連付け (Associations) のテスト
  describe 'associations' do
    # quiz_attempts と 1:N の関係 (has_many) があり、
    # User 削除時に quiz_attempts も削除 (dependent: :destroy) されること
    it { should have_many(:quiz_attempts).dependent(:destroy) }

    # user_flags と 1:N の関係 (has_many) があり、
    # User 削除時に user_flags も削除 (dependent: :destroy) されること
    it { should have_many(:user_flags).dependent(:destroy) }

    # user_flags を通じて countries と N:N の関係 (has_many :through) があること
    it { should have_many(:countries).through(:user_flags) }
  end

end
