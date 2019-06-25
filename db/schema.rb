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

ActiveRecord::Schema.define(version: 2019_06_24_142540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "delayed_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "filename", limit: 40, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "site_id", null: false
    t.index ["filename"], name: "index_images_on_filename", unique: true
    t.index ["site_id", "name"], name: "index_images_on_site_id_and_name", unique: true
    t.index ["site_id"], name: "index_images_on_site_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "email", limit: 64, null: false
    t.string "phone", limit: 32
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "privacy_policy_agreed", default: false
    t.uuid "site_id", null: false
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["site_id"], name: "index_messages_on_site_id"
  end

  create_table "pages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url", limit: 64, null: false
    t.string "name", limit: 64, null: false
    t.boolean "private", default: false, null: false
    t.boolean "contact_form", default: false, null: false
    t.text "html_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "main_menu_position"
    t.text "custom_html"
    t.boolean "hidden", default: false, null: false
    t.uuid "site_id", null: false
    t.index ["site_id", "main_menu_position"], name: "index_pages_on_site_id_and_main_menu_position", unique: true
    t.index ["site_id", "url"], name: "index_pages_on_site_id_and_url", unique: true
    t.index ["site_id"], name: "index_pages_on_site_id"
  end

  create_table "sites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "host", limit: 64, null: false
    t.string "name", limit: 64, null: false
    t.string "google_analytics", limit: 32
    t.string "charity_number", limit: 32
    t.text "sidebar_html_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "main_menu_in_footer", default: false, null: false
    t.boolean "separate_header", default: true, null: false
    t.jsonb "links", default: []
    t.string "email", null: false
    t.text "css"
    t.uuid "privacy_policy_page_id"
    t.index ["host"], name: "index_sites_on_host", unique: true
  end

  create_table "versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "item_type", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.uuid "item_id", null: false
    t.index ["created_at"], name: "index_versions_on_created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "images", "sites", name: "fk_images_site_id"
  add_foreign_key "messages", "sites", name: "fk_messages_site_id"
  add_foreign_key "pages", "sites", name: "fk_pages_site_id"
  add_foreign_key "sites", "pages", column: "privacy_policy_page_id", name: "fk__sites_privacy_policy_page_id"
end
