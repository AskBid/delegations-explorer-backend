# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_13_214842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_stakes", force: :cascade do |t|
    t.string "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "epochno"
    t.string "rewards"
    t.integer "pool_id"
    t.integer "stake_id"
  end

  create_table "pool_owners", force: :cascade do |t|
    t.string "hashid"
    t.integer "pool_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pool_reward_addresses", force: :cascade do |t|
    t.string "address"
    t.integer "pool_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pools", force: :cascade do |t|
    t.string "poolid"
    t.string "hashid"
    t.integer "updatedIn"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
    t.string "ticker"
  end

  create_table "stakes", force: :cascade do |t|
    t.string "address"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

end
