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

ActiveRecord::Schema[7.0].define(version: 2024_10_24_150715) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "educations", force: :cascade do |t|
    t.string "educationName"
    t.string "educationType"
    t.string "educationDescription"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "photoLink"
    t.string "photoDescription"
    t.string "photoType"
    t.string "photoPageLocation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "projectName"
    t.string "projectDesc"
    t.integer "locationID"
    t.date "projectStartDate"
    t.boolean "isProjectActive"
    t.text "markdownBody"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sponsorships", force: :cascade do |t|
    t.string "sponsor_name"
    t.string "sponsor_lead_name"
    t.string "sponsor_phone"
    t.string "sponsor_email"
    t.decimal "sponsor_donation"
    t.date "sponsor_end_of_contract"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_user_projects_on_project_id"
    t.index ["user_id"], name: "index_user_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.integer "class_year"
    t.date "ring_date"
    t.date "grad_date"
    t.date "birthday"
    t.string "shirt_size"
    t.string "dietary_restriction"
    t.boolean "account_complete", default: false
    t.string "linkedin_url"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "user_projects", "projects"
  add_foreign_key "user_projects", "users"
end
