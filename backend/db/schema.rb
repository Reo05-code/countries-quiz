ActiveRecord::Schema[7.1].define(version: 2025_11_15_063543) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "hint_1"
    t.string "hint_2"
    t.string "hint_3"
    t.string "hint_4"
    t.string "flag_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "country_id", null: false
    t.boolean "correct", default: false, null: false
    t.integer "hint_level"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["country_id"], name: "index_quiz_attempts_on_country_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "user_flags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_user_flags_on_country_id"
    t.index ["user_id"], name: "index_user_flags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "quiz_attempts", "countries"
  add_foreign_key "quiz_attempts", "users"
  add_foreign_key "user_flags", "countries"
  add_foreign_key "user_flags", "users"
end
