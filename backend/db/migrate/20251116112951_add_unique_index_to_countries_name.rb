class AddUniqueIndexToCountriesName < ActiveRecord::Migration[7.1]
  def change
    add_index :countries, :name, unique: true
  end
end
