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

ActiveRecord::Schema.define(version: 20150225105001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.integer  "site_id",                  null: false
    t.string   "name",          limit: 64, null: false
    t.string   "filename",      limit: 36
    t.integer  "created_by_id",            null: false
    t.integer  "updated_by_id",            null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "images", ["created_by_id"], name: "index_images_on_created_by_id", using: :btree
  add_index "images", ["site_id", "filename"], name: "index_images_on_site_id_and_filename", unique: true, using: :btree
  add_index "images", ["site_id", "name"], name: "index_images_on_site_id_and_name", unique: true, using: :btree
  add_index "images", ["site_id"], name: "index_images_on_site_id", using: :btree
  add_index "images", ["updated_by_id"], name: "index_images_on_updated_by_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "site_id",                               null: false
    t.string   "subject",    limit: 64,                 null: false
    t.string   "name",       limit: 64,                 null: false
    t.string   "email",      limit: 64,                 null: false
    t.string   "phone",      limit: 32
    t.boolean  "delivered",             default: false, null: false
    t.text     "message",                               null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "messages", ["site_id"], name: "index_messages_on_site_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.integer  "site_id",                                  null: false
    t.string   "url",           limit: 64,                 null: false
    t.string   "name",          limit: 64,                 null: false
    t.boolean  "private",                  default: false, null: false
    t.boolean  "contact_form",             default: false, null: false
    t.text     "html_content"
    t.integer  "created_by_id",                            null: false
    t.integer  "updated_by_id",                            null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "pages", ["created_by_id"], name: "index_pages_on_created_by_id", using: :btree
  add_index "pages", ["site_id", "url"], name: "index_pages_on_site_id_and_url", unique: true, using: :btree
  add_index "pages", ["site_id"], name: "index_pages_on_site_id", using: :btree
  add_index "pages", ["updated_by_id"], name: "index_pages_on_updated_by_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "host",                  limit: 64,                        null: false
    t.string   "name",                  limit: 64,                        null: false
    t.string   "sub_title",             limit: 64
    t.string   "layout",                limit: 32, default: "one_column"
    t.text     "main_menu_page_ids"
    t.string   "copyright",             limit: 64
    t.string   "google_analytics",      limit: 32
    t.string   "charity_number",        limit: 32
    t.string   "stylesheet_filename",   limit: 36
    t.string   "header_image_filename", limit: 36
    t.text     "sidebar_html_content"
    t.integer  "created_by_id",                                           null: false
    t.integer  "updated_by_id",                                           null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.boolean  "main_menu_in_footer",              default: false,        null: false
    t.boolean  "separate_header",                  default: true,         null: false
  end

  add_index "sites", ["created_by_id"], name: "index_sites_on_created_by_id", using: :btree
  add_index "sites", ["host"], name: "index_sites_on_host", unique: true, using: :btree
  add_index "sites", ["updated_by_id"], name: "index_sites_on_updated_by_id", using: :btree

  create_table "sites_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "site_id", null: false
  end

  add_index "sites_users", ["site_id"], name: "index_sites_users_on_site_id", using: :btree
  add_index "sites_users", ["user_id"], name: "index_sites_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 64,             null: false
    t.string   "encrypted_password",     limit: 64,             null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "sign_in_count",                     default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",                   default: 0, null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
