# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2020_11_06_110241) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "crawl_sessions", force: :cascade do |t|
    t.bigint "website_id", null: false
    t.integer "enqueued_count", default: 0, null: false
    t.integer "processed_count", default: 0, null: false
    t.integer "error_count", default: 0, null: false
    t.text "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["website_id"], name: "index_crawl_sessions_on_website_id"
  end

  create_table "custom_rule_results", force: :cascade do |t|
    t.bigint "custom_rule_id", null: false
    t.bigint "website_page_id", null: false
    t.text "message", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_rule_id", "website_page_id", "message"], name: "custom_rule_results_text_context_website_page_id_unique_index", unique: true
    t.index ["website_page_id"], name: "index_custom_rule_results_on_website_page_id"
  end

  create_table "custom_rules", force: :cascade do |t|
    t.bigint "website_id", null: false
    t.text "condition", null: false
    t.text "pattern", null: false
    t.jsonb "paths", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["website_id"], name: "index_custom_rules_on_website_id"
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "first_name"
    t.text "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "website_page_errors", force: :cascade do |t|
    t.bigint "website_page_id", null: false
    t.text "text", null: false
    t.text "correction", null: false
    t.text "error_type", null: false
    t.text "context", null: false
    t.text "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_website_page_errors_on_created_at", using: :brin
    t.index ["text", "context", "website_page_id"], name: "website_page_errors_text_context_website_page_id_unique_index", unique: true
    t.index ["website_page_id"], name: "index_website_page_errors_on_website_page_id"
  end

  create_table "website_page_website_resources", force: :cascade do |t|
    t.bigint "website_page_id", null: false
    t.bigint "website_resource_id"
    t.boolean "is_resolved", default: false, null: false
    t.index ["website_page_id", "website_resource_id"], name: "website_page_website_resources_index", unique: true
    t.index ["website_resource_id"], name: "index_website_page_website_resources_on_website_resource_id"
  end

  create_table "website_pages", force: :cascade do |t|
    t.bigint "website_id", null: false
    t.text "title", null: false
    t.text "url", null: false
    t.text "sha1", null: false
    t.text "lang", null: false
    t.text "status", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_website_pages_on_created_at", using: :brin
    t.index ["website_id", "url", "sha1"], name: "index_website_pages_on_website_id_and_url_and_sha1", unique: true
    t.index ["website_id", "url"], name: "index_website_pages_on_website_id_and_url", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "website_resources", force: :cascade do |t|
    t.bigint "website_id", null: false
    t.text "url", null: false
    t.text "effective_url", null: false
    t.text "status", null: false
    t.text "resource_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["website_id", "status"], name: "index_website_resources_on_website_id_and_status"
    t.index ["website_id", "url"], name: "index_website_resources_on_website_id_and_url", unique: true
  end

  create_table "websites", force: :cascade do |t|
    t.citext "domain", null: false
    t.citext "slug", null: false
    t.citext "url", null: false
    t.text "status", null: false
    t.jsonb "preferences", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_websites_on_domain", unique: true
    t.index ["slug"], name: "index_websites_on_slug", unique: true
  end

  add_foreign_key "crawl_sessions", "websites"
  add_foreign_key "custom_rule_results", "custom_rules"
  add_foreign_key "custom_rule_results", "website_pages"
  add_foreign_key "custom_rules", "websites"
  add_foreign_key "website_page_errors", "website_pages"
  add_foreign_key "website_page_website_resources", "website_pages"
  add_foreign_key "website_page_website_resources", "website_resources"
  add_foreign_key "website_pages", "websites"
  add_foreign_key "website_resources", "websites"
end
