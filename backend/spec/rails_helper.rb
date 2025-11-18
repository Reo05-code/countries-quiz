# RSpecの基本的な設定ファイル（spec/spec_helper.rb）をまず読み込みます。
require "spec_helper"

# もし環境変数が設定されていなければ、Railsの実行環境を 'test'（テスト用）に設定します。
ENV["RAILS_ENV"] ||= "test"

# Railsアプリケーション本体を読み込みます（これでRailsの機能がテスト内で使えるようになります）。
require_relative "../config/environment"

# 【重要】もしRailsの環境が 'production'（本番環境）だったら、
# テストを実行すると本番DBのデータが消える危険があるため、エラーを出して即座に停止させます。
# Rails/Exit: Railsアプリでは abort ではなく raise を使用
raise "The Rails environment is running in production mode!" if Rails.env.production?

# RSpecでRailsのテストを行うための設定を読み込みます。
require "rspec/rails"

# ---
# spec/support/ フォルダ内にある、ヘルパーファイル（*.rb）をすべて自動で読み込みます。
# （例: ログイン処理のヘルパーなどをここに入れておくと便利です）
# ---
Rails.root.glob("spec/support/**/*.rb").each { |f| require f }

# ---
# 未実行のマイグレーション（DBの構造変更）が残っていないかチェックします。
# ---
begin
  # テスト用データベースのスキーマ（構造）を最新の状態に保ちます。
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  # もし未実行のマイグレーションがあれば、エラーメッセージを表示してテストを停止します。
  # Rails/Exit: Railsアプリでは abort ではなく raise を使用
  raise e.to_s.strip
end

# === RSpecの全体設定 ===
RSpec.configure do |config|
  # ----------------------------------------------------------------
  # フィクスチャ（テスト用の固定データ）を使う場合、その置き場所を指定します。
  # ----------------------------------------------------------------
  # ※FactoryBotを使う場合は、この設定はあまり意識しなくても大丈夫です。
  config.fixture_paths = [Rails.root.join("spec/fixtures")]

  # ----------------------------------------------------------------
  # 【重要】トランザクションを使ったテスト実行（use_transactional_fixtures）
  # ----------------------------------------------------------------
  # これが 'true' の場合、各テスト（example）は「トランザクション」の中で実行されます。
  # テストが終了すると、そのトランザクションが「ロールバック（元に戻る）」されるため、
  # データベースに行った変更（createしたデータなど）が自動的に消去されます。
  # これにより、テスト同士が影響し合わないようになります。
  config.use_transactional_fixtures = true

  # ----------------------------------------------------------------
  # エラー発生時のバックトレース（エラー箇所の追跡ログ）から、
  # Railsのgem内部の情報を除外し、ログを見やすくします。
  # ----------------------------------------------------------------
  config.filter_rails_from_backtrace!

  # ----------------------------------------------------------------
  # FactoryBotのメソッド（build, create など）を、
  # `FactoryBot.build` と書かずに `build` だけで使えるようにします。
  # ----------------------------------------------------------------
  config.include FactoryBot::Syntax::Methods

  # ----------------------------------------------------------------
  # テストファイルの設置場所（ディレクトリ）から、
  # そのテストの種類（:model, :controller, :system など）を自動的に推測します。
  # 例: spec/models/ 以下のテストは、自動的に :model タイプとして扱われます。
  # ----------------------------------------------------------------
  config.infer_spec_type_from_file_location!
end
