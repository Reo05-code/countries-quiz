class CreateCountryQuizSchema < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.string :name, null: false
      t.string :hint_1
      t.string :hint_2
      t.string :hint_3
      t.string :hint_4
      t.string :flag_url

      t.timestamps
    end

    create_table :users do |t|
      t.string :name, null: false
      t.string :email

      t.timestamps
    end

    create_table :user_flags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end

    create_table :quiz_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.boolean :correct, null: false, default: false
      t.integer :hint_level
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
