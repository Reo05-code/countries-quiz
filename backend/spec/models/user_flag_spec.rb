require 'rails_helper'

RSpec.describe UserFlag, type: :model do

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:country) }
  end

  describe 'validations' do
    # uniqueness（一意性）のテストは、DBに既存のレコードが必要なため、
    # subjectで `create` を使って先にDBに保存しておきます。
    subject { create(:user_flag) }

    # `user_id` と `country_id` の組み合わせがユニークであるかをテスト
    it do
      should validate_uniqueness_of(:user_id)
        .scoped_to(:country_id) # <- scope をテストするマッチャー
        .with_message("はすでにこの国旗を獲得済みです") # <- メッセージもテスト
    end
  end

  # --- 3. ファクトリ自体のテスト ---
  describe 'factory' do
    it '有効なファクトリを持つこと' do
      # build(:user_flag) で有効な（バリデーションを通る）データが作れることを確認
      expect(build(:user_flag)).to be_valid
    end
  end
end
