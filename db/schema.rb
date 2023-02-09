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

ActiveRecord::Schema[7.0].define(version: 2023_02_05_221208) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "sender_id"
    t.uuid "receiver_id"
    t.uuid "last_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_message_id"], name: "index_chats_on_last_message_id"
    t.index ["receiver_id"], name: "index_chats_on_receiver_id"
    t.index ["sender_id"], name: "index_chats_on_sender_id"
  end

  create_table "friends", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "sender_id"
    t.uuid "receiver_id"
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_friends_on_receiver_id"
    t.index ["sender_id"], name: "index_friends_on_sender_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "sender_id"
    t.uuid "receiver_id"
    t.string "content"
    t.boolean "received", default: false
    t.boolean "readed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.boolean "status", default: false
    t.string "profile_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username"
  end

end
