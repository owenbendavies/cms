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

ActiveRecord::Schema.define(version: 2018_06_26_114144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
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

  create_table "images", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "name", limit: 64, null: false
    t.string "filename", limit: 40, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "index_images_on_filename", unique: true
    t.index ["site_id", "name"], name: "index_images_on_site_id_and_name", unique: true
    t.index ["site_id"], name: "index_images_on_site_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "name", limit: 64, null: false
    t.string "email", limit: 64, null: false
    t.string "phone", limit: 32
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid", null: false
    t.boolean "privacy_policy_agreed", default: false
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["site_id"], name: "index_messages_on_site_id"
    t.index ["uid"], name: "index_messages_on_uid", unique: true
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
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
    t.index ["site_id", "main_menu_position"], name: "index_pages_on_site_id_and_main_menu_position", unique: true
    t.index ["site_id", "url"], name: "index_pages_on_site_id_and_url", unique: true
    t.index ["site_id"], name: "index_pages_on_site_id"
  end

  create_table "site_settings", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "site_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["site_id"], name: "index_site_settings_on_site_id"
    t.index ["user_id", "site_id"], name: "index_site_settings_on_user_id_and_site_id", unique: true
    t.index ["user_id"], name: "index_site_settings_on_user_id"
  end

  create_table "sites", id: :serial, force: :cascade do |t|
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
    t.integer "privacy_policy_page_id"
    t.string "uid", null: false
    t.index ["host"], name: "index_sites_on_host", unique: true
    t.index ["uid"], name: "index_sites_on_uid", unique: true
  end

  create_table "stylesheets", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.text "css", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_stylesheets_on_site_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 64, null: false
    t.string "encrypted_password", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "sysadmin", default: false, null: false
    t.string "name", limit: 64, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invited_by_id"
    t.string "google_uid"
    t.string "uid", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["created_at"], name: "index_versions_on_created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "images", "sites", name: "fk_images_site_id"
  add_foreign_key "messages", "sites", name: "fk_messages_site_id"
  add_foreign_key "pages", "sites", name: "fk_pages_site_id"
  add_foreign_key "site_settings", "sites", name: "fk_site_settings_site_id"
  add_foreign_key "site_settings", "users", name: "fk_site_settings_user_id"
  add_foreign_key "sites", "pages", column: "privacy_policy_page_id", name: "fk__sites_privacy_policy_page_id"
  add_foreign_key "stylesheets", "sites", name: "fk_stylesheets_site_id"
  add_foreign_key "users", "users", column: "invited_by_id", name: "fk_users_invited_by_id"
end
