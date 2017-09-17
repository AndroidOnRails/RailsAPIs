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

ActiveRecord::Schema.define(version: 20170907095924) do

  create_table "currents", force: :cascade do |t|
    t.text "crypto_curr"
    t.text "curr"
    t.integer "exchange_id"
    t.datetime "date_time"
    t.float "buy"
    t.float "sell"
    t.float "last_hour_min"
    t.float "last_day_min"
    t.float "last_week_min"
    t.float "last_month_min"
    t.float "last_hour_max"
    t.float "last_day_max"
    t.float "last_week_max"
    t.float "last_month_max"
    t.index ["crypto_curr", "curr", "exchange_id"], name: "crypto_curr_id", unique: true
  end

  create_table "histories", force: :cascade do |t|
    t.text "crypto_curr"
    t.text "curr"
    t.integer "exchange_id"
    t.datetime "date_time"
    t.float "buy"
    t.float "sell"
  end

end
