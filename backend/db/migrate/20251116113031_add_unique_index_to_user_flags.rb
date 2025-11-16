class AddUniqueIndexToUserFlags < ActiveRecord::Migration[7.1]
  def change
    add_index :user_flags, [:user_id, :country_id], unique: true
  end
end
