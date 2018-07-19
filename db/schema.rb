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

ActiveRecord::Schema.define(version: 20180625121644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

  create_table "admins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bajajs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "number_plate"
    t.string "phone_number"
    t.string "stage"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "btrip_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "phone_number"
    t.string "location"
    t.uuid "bajaj_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "sms_id"
    t.index ["bajaj_id"], name: "index_btrip_requests_on_bajaj_id"
    t.index ["sms_id"], name: "index_btrip_requests_on_sms_id", unique: true
  end

  create_table "btrips", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status"
    t.uuid "btrip_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["btrip_request_id"], name: "index_btrips_on_btrip_request_id", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "sms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "message"
    t.string "transport_mode"
    t.string "phone_number"
    t.string "current_location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "duplicate", default: false
  end

  create_table "sms_btrip_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "phone_number"
    t.string "sent_sms"
    t.string "received_sms"
    t.string "status"
    t.uuid "btrip_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["btrip_request_id"], name: "index_sms_btrip_requests_on_btrip_request_id"
  end

  create_table "sms_ttrip_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "phone_number"
    t.string "sent_sms"
    t.string "received_sms"
    t.string "status"
    t.uuid "ttrip_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ttrip_request_id"], name: "index_sms_ttrip_requests_on_ttrip_request_id"
  end

  create_table "ttrip_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "phone_number"
    t.string "location"
    t.uuid "tuktuk_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "sms_id"
    t.index ["sms_id"], name: "index_ttrip_requests_on_sms_id", unique: true
    t.index ["tuktuk_id"], name: "index_ttrip_requests_on_tuktuk_id"
  end

  create_table "ttrips", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status"
    t.uuid "ttrip_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ttrip_request_id"], name: "index_ttrips_on_ttrip_request_id", unique: true
  end

  create_table "tuktuks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "number_plate"
    t.string "phone_number"
    t.string "stage"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
