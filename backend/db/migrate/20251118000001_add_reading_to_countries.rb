class AddReadingToCountries < ActiveRecord::Migration[7.1]
  def change
    add_column :countries, :reading, :string, null: false, default: ""
    add_index :countries, :reading
  end
end
