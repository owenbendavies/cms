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

ActiveRecord::Schema.define(version: 20141204075305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "email",           limit: 64, null: false
    t.string   "password_digest", limit: 64, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree

  create_table "accounts_sites", id: false, force: true do |t|
    t.integer "account_id", null: false
    t.integer "site_id",    null: false
  end

  add_index "accounts_sites", ["account_id"], name: "index_accounts_sites_on_account_id", using: :btree
  add_index "accounts_sites", ["site_id"], name: "index_accounts_sites_on_site_id", using: :btree

  create_table "images", force: true do |t|
    t.integer  "site_id",                  null: false
    t.string   "name",          limit: 64, null: false
    t.string   "filename",      limit: 36, null: false
    t.integer  "created_by_id",            null: false
    t.integer  "updated_by_id",            null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "images", ["created_by_id"], name: "index_images_on_created_by_id", using: :btree
  add_index "images", ["site_id"], name: "index_images_on_site_id", using: :btree
  add_index "images", ["updated_by_id"], name: "index_images_on_updated_by_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "site_id",                               null: false
    t.string   "subject",                               null: false
    t.string   "name",       limit: 64,                 null: false
    t.string   "email",      limit: 64,                 null: false
    t.string   "phone",      limit: 32
    t.boolean  "delivered",             default: false, null: false
    t.text     "message",                               null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "messages", ["site_id"], name: "index_messages_on_site_id", using: :btree

  create_table "pages", force: true do |t|
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

  create_table "sites", force: true do |t|
    t.string   "host",                  limit: 64,                        null: false
    t.string   "name",                  limit: 64,                        null: false
    t.string   "sub_title",             limit: 64
    t.string   "layout",                           default: "one_column"
    t.string   "main_menu_page_ids"
    t.string   "copyright",             limit: 64
    t.string   "google_analytics"
    t.string   "charity_number"
    t.string   "stylesheet_filename",   limit: 36
    t.string   "header_image_filename", limit: 36
    t.text     "sidebar_html_content"
    t.integer  "created_by_id",                                           null: false
    t.integer  "updated_by_id",                                           null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "sites", ["created_by_id"], name: "index_sites_on_created_by_id", using: :btree
  add_index "sites", ["host"], name: "index_sites_on_host", unique: true, using: :btree
  add_index "sites", ["updated_by_id"], name: "index_sites_on_updated_by_id", using: :btree

end
