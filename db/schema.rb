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

ActiveRecord::Schema[8.1].define(version: 2026_07_30_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "area", null: false, comment: "区域"
    t.datetime "created_at", null: false
    t.string "level", null: false, comment: "客户等级"
    t.string "name", null: false, comment: "客户名称"
    t.datetime "updated_at", null: false
    t.index ["area"], name: "index_customers_on_area"
    t.index ["level"], name: "index_customers_on_level"
    t.index ["name"], name: "index_customers_on_name"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false, comment: "订单"
    t.decimal "price", precision: 10, scale: 2, null: false, comment: "单价"
    t.bigint "product_id", null: false, comment: "产品"
    t.integer "qty", null: false, comment: "数量"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false, comment: "客户"
    t.date "delivery_date", null: false, comment: "交付日期"
    t.decimal "total_amount", precision: 12, scale: 2, default: "0.0", null: false, comment: "订单总额"
    t.integer "total_qty", default: 0, null: false, comment: "订单总数量"
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["delivery_date"], name: "index_orders_on_delivery_date"
  end

  create_table "products", force: :cascade do |t|
    t.string "category", null: false, comment: "产品类别"
    t.datetime "created_at", null: false
    t.string "name", null: false, comment: "产品名称"
    t.decimal "price", precision: 10, scale: 2, null: false, comment: "单价"
    t.integer "status", default: 0, null: false, comment: "状态"
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_products_on_category"
    t.index ["name"], name: "index_products_on_name"
    t.index ["status"], name: "index_products_on_status"
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "customers"
end
