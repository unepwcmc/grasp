# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160927163754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "post_code"
    t.string   "country"
  end

  create_table "bulk_uploads", force: :cascade do |t|
    t.json     "happy_accidents"
    t.boolean  "successful"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expertises", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "kind"
  end

  create_table "expertises_users", id: false, force: :cascade do |t|
    t.integer "expertise_id", null: false
    t.integer "user_id",      null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "report_id"
  end

  create_table "reports", force: :cascade do |t|
    t.jsonb    "data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.integer  "bulk_upload_id"
  end

  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "role_id"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "agency_id"
    t.string   "second_email"
    t.string   "skype_username"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "post_code"
    t.string   "country"
    t.string   "mobile_number"
  end

  add_index "users", ["agency_id"], name: "index_users_on_agency_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  create_table "validations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "report_id"
    t.text     "comments_for_provider"
    t.text     "comments_for_admin"
    t.string   "state"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "validations", ["report_id"], name: "index_validations_on_report_id", using: :btree
  add_index "validations", ["user_id"], name: "index_validations_on_user_id", using: :btree

  add_foreign_key "reports", "users"
  add_foreign_key "users", "agencies"
  add_foreign_key "users", "roles"
  add_foreign_key "validations", "reports"
  add_foreign_key "validations", "users"
end
