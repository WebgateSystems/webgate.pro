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

ActiveRecord::Schema.define(version: 20150202084928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "altlink"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_translations", force: true do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "altlink"
    t.text     "description"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "link_translations", force: true do |t|
    t.string   "link"
    t.string   "locale"
    t.string   "link_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_translations", force: true do |t|
    t.integer  "member_id",   null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "shortdesc"
    t.text     "description"
    t.text     "motto"
  end

  add_index "member_translations", ["locale"], name: "index_member_translations_on_locale", using: :btree
  add_index "member_translations", ["member_id"], name: "index_member_translations_on_member_id", using: :btree

  create_table "members", force: true do |t|
    t.string   "name"
    t.text     "shortdesc"
    t.text     "description"
    t.text     "motto"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members_technologies", id: false, force: true do |t|
    t.integer "member_id"
    t.integer "technology_id"
  end

  add_index "members_technologies", ["member_id"], name: "index_members_technologies_on_member_id", using: :btree
  add_index "members_technologies", ["technology_id"], name: "index_members_technologies_on_technology_id", using: :btree

  create_table "page_translations", force: true do |t|
    t.integer  "page_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "shortlink"
    t.text     "description"
    t.text     "keywords"
    t.text     "content"
    t.text     "tooltip"
  end

  add_index "page_translations", ["locale"], name: "index_page_translations_on_locale", using: :btree
  add_index "page_translations", ["page_id"], name: "index_page_translations_on_page_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "shortlink"
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
    t.text     "content"
    t.integer  "position"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_translations", force: true do |t|
    t.integer  "project_id",  null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "shortlink"
    t.text     "description"
    t.text     "keywords"
    t.text     "content"
  end

  add_index "project_translations", ["locale"], name: "index_project_translations_on_locale", using: :btree
  add_index "project_translations", ["project_id"], name: "index_project_translations_on_project_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "shortlink"
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "livelink"
    t.boolean  "publish",     default: false
  end

  create_table "projects_technologies", id: false, force: true do |t|
    t.integer "project_id"
    t.integer "technology_id"
  end

  add_index "projects_technologies", ["project_id"], name: "index_projects_technologies_on_project_id", using: :btree
  add_index "projects_technologies", ["technology_id"], name: "index_projects_technologies_on_technology_id", using: :btree

  create_table "screenshots", force: true do |t|
    t.string   "file"
    t.integer  "project_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technologies", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "technology_group_id"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technology_group_translations", force: true do |t|
    t.integer  "technology_group_id", null: false
    t.string   "locale",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
  end

  add_index "technology_group_translations", ["locale"], name: "index_technology_group_translations_on_locale", using: :btree
  add_index "technology_group_translations", ["technology_group_id"], name: "index_technology_group_translations_on_technology_group_id", using: :btree

  create_table "technology_groups", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technology_translations", force: true do |t|
    t.integer  "technology_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "technology_translations", ["locale"], name: "index_technology_translations_on_locale", using: :btree
  add_index "technology_translations", ["technology_id"], name: "index_technology_translations_on_technology_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                    null: false
    t.string   "crypted_password",                         null: false
    t.string   "salt",                                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.integer  "failed_logins_count",          default: 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree

end
