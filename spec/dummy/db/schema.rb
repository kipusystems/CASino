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

ActiveRecord::Schema[7.2].define(version: 2016_05_02_074450) do
  create_table "casino_auth_token_tickets", force: :cascade do |t|
    t.string "ticket", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket"], name: "index_casino_auth_token_tickets_on_ticket", unique: true
  end

  create_table "casino_login_attempts", force: :cascade do |t|
    t.integer "user_id"
    t.string "username"
    t.boolean "successful", default: false
    t.string "user_ip"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "casino_login_tickets", force: :cascade do |t|
    t.string "ticket", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket"], name: "index_casino_login_tickets_on_ticket", unique: true
  end

  create_table "casino_proxy_granting_tickets", force: :cascade do |t|
    t.string "ticket", null: false
    t.string "iou", null: false
    t.integer "granter_id", null: false
    t.string "pgt_url", null: false
    t.string "granter_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["granter_type", "granter_id"], name: "index_casino_proxy_granting_tickets_on_granter", unique: true
    t.index ["granter_type", "granter_id"], name: "index_proxy_granting_tickets_on_granter", unique: true
    t.index ["iou"], name: "index_casino_proxy_granting_tickets_on_iou", unique: true
    t.index ["ticket"], name: "index_casino_proxy_granting_tickets_on_ticket", unique: true
  end

  create_table "casino_proxy_tickets", force: :cascade do |t|
    t.string "ticket", null: false
    t.text "service"
    t.boolean "consumed", default: false, null: false
    t.integer "proxy_granting_ticket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proxy_granting_ticket_id"], name: "casino_proxy_tickets_on_pgt_id"
    t.index ["ticket"], name: "index_casino_proxy_tickets_on_ticket", unique: true
  end

  create_table "casino_service_rules", force: :cascade do |t|
    t.boolean "enabled", default: true, null: false
    t.integer "order", default: 10, null: false
    t.string "name", null: false
    t.string "url", null: false
    t.boolean "regex", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_casino_service_rules_on_url", unique: true
  end

  create_table "casino_service_tickets", force: :cascade do |t|
    t.string "ticket", null: false
    t.text "service"
    t.integer "ticket_granting_ticket_id"
    t.boolean "consumed", default: false, null: false
    t.boolean "issued_from_credentials", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket"], name: "index_casino_service_tickets_on_ticket", unique: true
    t.index ["ticket_granting_ticket_id"], name: "casino_service_tickets_on_tgt_id"
  end

  create_table "casino_ticket_granting_tickets", force: :cascade do |t|
    t.string "ticket", null: false
    t.text "user_agent"
    t.integer "user_id", null: false
    t.boolean "awaiting_two_factor_authentication", default: false, null: false
    t.boolean "long_term", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_ip"
    t.index ["ticket"], name: "index_casino_ticket_granting_tickets_on_ticket", unique: true
  end

  create_table "casino_two_factor_authenticators", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "secret", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_casino_two_factor_authenticators_on_user_id"
  end

  create_table "casino_users", force: :cascade do |t|
    t.string "authenticator", null: false
    t.string "username", null: false
    t.text "extra_attributes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authenticator", "username"], name: "index_casino_users_on_authenticator_and_username", unique: true
  end
end
