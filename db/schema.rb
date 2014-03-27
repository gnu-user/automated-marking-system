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

ActiveRecord::Schema.define(version: 20140327135622) do

  create_table "clone_incidents", force: true do |t|
    t.integer  "similarity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compiler_issues", force: true do |t|
    t.text     "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diff_entries", force: true do |t|
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diff_files", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "io_elements", force: true do |t|
    t.text     "value"
    t.boolean  "input"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", force: true do |t|
    t.string   "method"
    t.integer  "line_number"
    t.integer  "col_number"
    t.string   "issue_type"
    t.text     "message"
    t.text     "relavent_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lines", force: true do |t|
    t.text     "text_line"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_analyses", force: true do |t|
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_issues", force: true do |t|
    t.integer  "line_number"
    t.string   "type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
