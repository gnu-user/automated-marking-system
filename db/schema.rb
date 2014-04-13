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

ActiveRecord::Schema.define(version: 20140409171623) do

  create_table "admins", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "prof_id"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: true do |t|
    t.integer  "admin_id"
    t.string   "name"
    t.text     "description"
    t.integer  "max_time"
    t.integer  "attempts"
    t.integer  "code_weight"
    t.integer  "test_case_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "released"
    t.datetime "posted"
    t.datetime "due"
  end

  create_table "clone_incidents", force: true do |t|
    t.float    "similarity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignment_id"
  end

  create_table "compiler_issues", force: true do |t|
    t.text     "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grade_id"
  end

  create_table "diff_entries", force: true do |t|
    t.string  "position"
    t.integer "diff_file_id"
  end

  create_table "diff_files", force: true do |t|
    t.string  "name"
    t.integer "clone_incident_id"
  end

  create_table "grades", force: true do |t|
    t.float    "final"
    t.float    "testcase"
    t.float    "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "submission_id"
  end

  create_table "inputs", force: true do |t|
    t.text     "value"
    t.boolean  "input"
    t.integer  "test_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", force: true do |t|
    t.string  "method"
    t.integer "line_number"
    t.integer "col_number"
    t.string  "issue_type"
    t.text    "message"
    t.text    "relavent_code"
    t.integer "compiler_issue_id"
  end

  create_table "lines", force: true do |t|
    t.text    "text_line"
    t.integer "diff_entry_id"
  end

  create_table "static_analyses", force: true do |t|
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grade_id"
  end

  create_table "static_issues", force: true do |t|
    t.integer "line_number"
    t.string  "type"
    t.text    "description"
    t.integer "static_analysis_id"
  end

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "student_id"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", force: true do |t|
    t.text     "code"
    t.integer  "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.integer  "submit_count"
  end

  create_table "test_cases", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "sample"
    t.integer  "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.integer  "test_case_id"
    t.boolean  "result"
    t.integer  "grade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
