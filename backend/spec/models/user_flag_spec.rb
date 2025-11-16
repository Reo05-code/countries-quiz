require "rails_helper"

RSpec.describe UserFlag do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:country) }
  end

  describe "validations" do
    # 1. ここで「名前付きsubject」を一回だけ定義します。
    #    これがDBに保存される「既存のレコード」になります。
    subject(:user_flag) { create(:user_flag) }

    # 2. 'it' ブロックの中では subject を定義しません。
    #    'it' は「テスト実行」のブロックです。
    it "user_id と country_id の組み合わせでユニークであること" do
      # 3. shoulda-matcher が subject (user_flag) を参照して、
      #    裏側で「重複するデータを作ろうとして失敗するか」を自動でテストしてくれます。
      expect(user_flag).to validate_uniqueness_of(:user_id)
        .scoped_to(:country_id) # <- scope をテストするマッチャー
        .with_message("はすでにこの国旗を獲得済みです") # <- メッセージもテスト
    end

    # (参考) 上記の 'it' ブロックは、以下のように1行でも書けます
    # it do
    #   is_expected.to validate_uniqueness_of(:user_id)
    #     .scoped_to(:country_id)
    #     .with_message("はすでにこの国旗を獲得済みです")
    # end
  end

  # --- 3. ファクトリ自体のテスト ---
  describe "factory" do
    it "有効なファクトリを持つこと" do
      # build(:user_flag) で有効な（バリデーションを通る）データが作れることを確認
      expect(build(:user_flag)).to be_valid
    end
  end
end
