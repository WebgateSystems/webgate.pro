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

ActiveRecord::Schema.define(version: 2015_06_04_100352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "altlink"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_translations", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "altlink"
    t.text "description"
    t.index ["category_id"], name: "index_category_translations_on_category_id"
    t.index ["locale"], name: "index_category_translations_on_locale"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "member_link_translations", force: :cascade do |t|
    t.bigint "member_link_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_member_link_translations_on_locale"
    t.index ["member_link_id"], name: "index_member_link_translations_on_member_link_id"
  end

  create_table "member_links", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.integer "member_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_links_on_member_id"
  end

  create_table "member_translations", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "education"
    t.text "description"
    t.text "motto"
    t.string "job_title"
    t.index ["locale"], name: "index_member_translations_on_locale"
    t.index ["member_id"], name: "index_member_translations_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.text "education"
    t.text "description"
    t.text "motto"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.boolean "publish", default: false
  end

  create_table "members_technologies", id: false, force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "technology_id"
    t.index ["member_id"], name: "index_members_technologies_on_member_id"
    t.index ["technology_id"], name: "index_members_technologies_on_technology_id"
  end

  create_table "page_translations", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "shortlink"
    t.text "description"
    t.text "keywords"
    t.text "content"
    t.text "tooltip"
    t.index ["locale"], name: "index_page_translations_on_locale"
    t.index ["page_id"], name: "index_page_translations_on_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "shortlink"
    t.string "title"
    t.text "description"
    t.text "keywords"
    t.text "content"
    t.integer "position"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "publish", default: false
    t.index ["category_id"], name: "index_pages_on_category_id"
  end

  create_table "project_translations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "content"
    t.index ["locale"], name: "index_project_translations_on_locale"
    t.index ["project_id"], name: "index_project_translations_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "shortlink"
    t.string "title"
    t.text "description"
    t.text "keywords"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "livelink"
    t.boolean "publish", default: false
    t.integer "position"
    t.string "collage"
  end

  create_table "projects_technologies", id: false, force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "technology_id"
    t.index ["project_id"], name: "index_projects_technologies_on_project_id"
    t.index ["technology_id"], name: "index_projects_technologies_on_technology_id"
  end

  create_table "screenshots", force: :cascade do |t|
    t.string "file"
    t.integer "project_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "technologies", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "technology_group_id"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.string "link"
    t.integer "member_position"
    t.index ["technology_group_id"], name: "index_technologies_on_technology_group_id"
  end

  create_table "technologies_members", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "technology_id"
    t.integer "position"
    t.index ["member_id", "technology_id"], name: "index_technologies_members_on_member_id_and_technology_id", unique: true
    t.index ["member_id"], name: "index_technologies_members_on_member_id"
    t.index ["technology_id"], name: "index_technologies_members_on_technology_id"
  end

  create_table "technologies_projects", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "technology_id"
    t.integer "position"
    t.index ["project_id", "technology_id"], name: "index_technologies_projects_on_project_id_and_technology_id", unique: true
    t.index ["project_id"], name: "index_technologies_projects_on_project_id"
    t.index ["technology_id"], name: "index_technologies_projects_on_technology_id"
  end

  create_table "technology_group_translations", force: :cascade do |t|
    t.bigint "technology_group_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "description"
    t.index ["locale"], name: "index_technology_group_translations_on_locale"
    t.index ["technology_group_id"], name: "index_technology_group_translations_on_technology_group_id"
  end

  create_table "technology_groups", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.integer "position"
  end

  create_table "technology_translations", force: :cascade do |t|
    t.bigint "technology_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "link"
    t.index ["locale"], name: "index_technology_translations_on_locale"
    t.index ["technology_id"], name: "index_technology_translations_on_technology_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password", null: false
    t.string "salt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at"
    t.string "unlock_token"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end

end
