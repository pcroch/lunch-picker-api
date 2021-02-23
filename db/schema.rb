# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_23_153506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lunch_preferences", force: :cascade do |t|
    t.bigint "lunch_id", null: false
    t.bigint "preference_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lunch_id"], name: "index_lunch_preferences_on_lunch_id"
    t.index ["preference_id"], name: "index_lunch_preferences_on_preference_id"
  end

  create_table "lunches", force: :cascade do |t|
    t.string "localisation"
    t.string "distance"
    t.string "price", default: [], array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_lunches_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "name"
    t.text "task", default: [], array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_preferences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "lunch_preferences", "lunches"
  add_foreign_key "lunch_preferences", "preferences"
  add_foreign_key "lunches", "users"
  add_foreign_key "preferences", "users"
end
