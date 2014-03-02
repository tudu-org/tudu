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

ActiveRecord::Schema.define(version: 20140302113933) do

  create_table "events", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recurring_events", force: true do |t|
    t.datetime "recurring_start_time"
    t.datetime "recurring_end_time"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "every_monday"
    t.boolean  "every_tuesday"
    t.boolean  "every_wednesday"
    t.boolean  "every_thursday"
    t.boolean  "every_friday"
    t.boolean  "every_saturday"
    t.boolean  "every_sunday"
    t.integer  "weeks_between"
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "name"
    t.text     "description"
    t.integer  "priority"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string  "email"
    t.string  "password"
    t.string  "password_confirmation"
    t.boolean "terms_of_service"
    t.string  "password_salt"
    t.string  "password_hash"
    t.string  "auth_token"
    t.string  "password_digest"
  end

end
