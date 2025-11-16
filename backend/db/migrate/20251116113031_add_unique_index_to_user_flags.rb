class AddUniqueIndexToUserFlags < ActiveRecord::Migration[7.1]
  def change
    # 重複データがあれば古い方を削除（ユニークインデックス追加前のクリーンアップ）
    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          DELETE FROM user_flags
          WHERE id NOT IN (
            SELECT MIN(id)
            FROM user_flags
            GROUP BY user_id, country_id
          );
        SQL
      end
    end

    add_index :user_flags, [:user_id, :country_id], unique: true
  end
end
