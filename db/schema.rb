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

ActiveRecord::Schema[7.0].define(version: 2022_08_14_193850) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.text "title", null: false
    t.text "source", null: false
    t.string "slug", null: false
    t.bigint "author_id"
    t.integer "status", default: 0, null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_articles_on_author_id"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "remark_id"
    t.text "caption"
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "recognition"
    t.index ["remark_id"], name: "index_photos_on_remark_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "remark_id", null: false
    t.bigint "user_id", null: false
    t.integer "kind", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remark_id", "user_id", "kind"], name: "index_reactions_on_remark_id_and_user_id_and_kind", unique: true
    t.index ["remark_id"], name: "index_reactions_on_remark_id"
    t.index ["user_id"], name: "index_reactions_on_user_id"
  end

  create_table "remarks", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.bigint "remark_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "nlp"
    t.jsonb "conversions_cache"
    t.datetime "conversions_cache_updated_at"
    t.index ["remark_id"], name: "index_remarks_on_remark_id"
    t.index ["user_id"], name: "index_remarks_on_user_id"
  end

  create_table "searchjoy_conversions", force: :cascade do |t|
    t.bigint "search_id"
    t.string "convertable_type"
    t.bigint "convertable_id"
    t.datetime "created_at"
    t.index ["convertable_type", "convertable_id"], name: "index_searchjoy_conversions_on_convertable"
    t.index ["search_id"], name: "index_searchjoy_conversions_on_search_id"
  end

  create_table "searchjoy_searches", force: :cascade do |t|
    t.bigint "user_id"
    t.string "search_type"
    t.string "query"
    t.string "normalized_query"
    t.integer "results_count"
    t.datetime "created_at"
    t.datetime "converted_at"
    t.index ["created_at"], name: "index_searchjoy_searches_on_created_at"
    t.index ["search_type", "created_at"], name: "index_searchjoy_searches_on_search_type_and_created_at"
    t.index ["search_type", "normalized_query", "created_at"], name: "index_searchjoy_searches_on_search_type_query"
    t.index ["user_id"], name: "index_searchjoy_searches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", limit: 128
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128
    t.boolean "admin", default: false, null: false
    t.jsonb "avatar_data"
    t.string "theme_preference"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

  add_foreign_key "articles", "users", column: "author_id"
  add_foreign_key "photos", "remarks"
  add_foreign_key "reactions", "remarks"
  add_foreign_key "reactions", "users"
  add_foreign_key "remarks", "remarks"
  add_foreign_key "remarks", "users"
end
