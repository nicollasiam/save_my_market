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

ActiveRecord::Schema.define(version: 2018_08_22_233232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "markets", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "price_histories", force: :cascade do |t|
    t.float "old_price"
    t.float "current_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.index ["product_id"], name: "index_price_histories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "image"
    t.string "market_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "market_id"
    t.string "slug"
    t.bigint "category_id"
    t.decimal "month_variation", precision: 10, scale: 2
    t.decimal "week_variation", precision: 10, scale: 2
    t.string "url"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["market_id"], name: "index_products_on_market_id"
  end

  add_foreign_key "price_histories", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "markets"
end
