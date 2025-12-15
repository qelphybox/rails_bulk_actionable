# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_15_124739) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "contact_type"
    t.string "contact_value"
    t.datetime "created_at", null: false
    t.bigint "person_id", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_contacts_on_person_id"
  end

  create_table "hobbies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_hobbies_on_name", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "updated_at", null: false
  end

  create_table "person_hobbies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "hobby_id", null: false
    t.bigint "person_id", null: false
    t.datetime "updated_at", null: false
    t.index ["hobby_id"], name: "index_person_hobbies_on_hobby_id"
    t.index ["person_id"], name: "index_person_hobbies_on_person_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "contacts", "people"
  add_foreign_key "person_hobbies", "hobbies"
  add_foreign_key "person_hobbies", "people"
  add_foreign_key "sessions", "users"
end
