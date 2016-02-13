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

ActiveRecord::Schema.define(version: 20160104202001) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "value",                  precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id",              default: 0
    t.string   "color"
  end

  create_table "credits", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "value",                  precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moneyboxes", force: :cascade do |t|
    t.decimal  "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "account_id"
    t.decimal  "summary"
  end

  create_table "operations", force: :cascade do |t|
    t.decimal  "value"
    t.integer  "type"
    t.string   "description",    limit: 255
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "transfer"
    t.datetime "operation_date"
  end

  create_table "operations_tags", force: :cascade do |t|
    t.integer "operation_id"
    t.integer "tag_id"
  end

  add_index "operations_tags", ["operation_id"], name: "index_operations_tags_on_operation_id"
  add_index "operations_tags", ["tag_id"], name: "index_operations_tags_on_tag_id"

  create_table "sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.integer  "expired_in"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "alias"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
