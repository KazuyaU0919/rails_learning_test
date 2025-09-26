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

ActiveRecord::Schema[8.0].define(version: 2025_09_25_232703) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authentications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid", unique: true
    t.index ["user_id", "provider"], name: "index_authentications_on_user_id_and_provider", unique: true
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "book_sections", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.string "heading", null: false
    t.text "content", null: false
    t.boolean "is_free", default: false, null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "position"], name: "index_book_sections_on_book_id_and_position", unique: true
    t.index ["book_id"], name: "index_book_sections_on_book_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pre_code_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pre_code_id"], name: "index_bookmarks_on_pre_code_id"
    t.index ["user_id", "pre_code_id"], name: "index_bookmarks_on_user_id_and_pre_code_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "book_sections_count", default: 0, null: false
    t.integer "position", null: false
    t.index ["position"], name: "index_books_on_position", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pre_code_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pre_code_id"], name: "index_likes_on_pre_code_id"
    t.index ["user_id", "pre_code_id"], name: "index_likes_on_user_id_and_pre_code_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "pre_code_taggings", force: :cascade do |t|
    t.bigint "pre_code_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pre_code_id", "tag_id"], name: "index_pre_code_taggings_on_pre_code_id_and_tag_id", unique: true
    t.index ["pre_code_id"], name: "index_pre_code_taggings_on_pre_code_id"
    t.index ["tag_id"], name: "index_pre_code_taggings_on_tag_id"
  end

  create_table "pre_codes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.text "body", null: false
    t.integer "like_count", default: 0, null: false
    t.integer "use_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "hint"
    t.text "answer"
    t.text "answer_code"
    t.index ["title"], name: "index_pre_codes_on_title"
    t.index ["user_id", "created_at"], name: "index_pre_codes_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_pre_codes_on_user_id"
  end

  create_table "solid_cache_entries", id: false, force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.string "name_norm", limit: 60, null: false
    t.string "slug", limit: 80, null: false
    t.string "color", limit: 7
    t.integer "taggings_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_norm"], name: "index_tags_on_name_norm", unique: true
    t.index ["slug"], name: "index_tags_on_slug", unique: true
    t.check_constraint "color IS NULL OR color::text ~ '^#[0-9A-Fa-f]{6}$'::text", name: "tags_color_hex"
  end

  create_table "used_codes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pre_code_id", null: false
    t.datetime "used_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pre_code_id", "created_at"], name: "index_used_codes_on_pre_code_id_and_created_at"
    t.index ["pre_code_id"], name: "index_used_codes_on_pre_code_id"
    t.index ["user_id", "pre_code_id"], name: "index_used_codes_on_user_id_and_pre_code_id"
    t.index ["user_id"], name: "index_used_codes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "email", limit: 255
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "editor", default: false, null: false
    t.datetime "banned_at"
    t.string "ban_reason"
    t.datetime "last_login_at"
    t.string "remember_digest"
    t.datetime "remember_created_at"
    t.index "lower((email)::text)", name: "index_users_on_lower_email_unique", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token_unique", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authentications", "users", on_delete: :cascade
  add_foreign_key "book_sections", "books"
  add_foreign_key "bookmarks", "pre_codes", on_delete: :cascade
  add_foreign_key "bookmarks", "users"
  add_foreign_key "likes", "pre_codes"
  add_foreign_key "likes", "users"
  add_foreign_key "pre_code_taggings", "pre_codes", on_delete: :cascade
  add_foreign_key "pre_code_taggings", "tags"
  add_foreign_key "pre_codes", "users"
  add_foreign_key "used_codes", "pre_codes"
  add_foreign_key "used_codes", "users"
end
