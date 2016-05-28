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

ActiveRecord::Schema.define(version: 20160528024732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cases", force: :cascade do |t|
    t.integer  "category_id", default: 0
    t.string   "title",       default: ""
    t.text     "content"
    t.integer  "priority",    default: 0
    t.boolean  "status",      default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "cases", ["category_id"], name: "index_cases_on_category_id", using: :btree
  add_index "cases", ["status"], name: "index_cases_on_status", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       default: ""
    t.integer  "parent_id",  default: 0
    t.integer  "priority",   default: 0
    t.boolean  "status",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["status"], name: "index_categories_on_status", using: :btree

end
