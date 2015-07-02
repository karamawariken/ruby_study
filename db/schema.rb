# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150701153607) do

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.integer  "low_user_id",  null: false
    t.integer  "high_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["low_user_id", "high_user_id"], name: "uses_pair_uniq_index", unique: true
  add_index "conversations", ["low_user_id"], name: "index_conversations_on_low_user_id"
  add_index "conversations", ["high_user_id"], name: "index_conversations_on_high_user_id"

  create_table "messages", force: true do |t|
    t.string   "content",         null: false
    t.integer  "sender_id",       null: false
    t.integer  "reciptient_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",            null: false
    t.integer  "conversation_id", null: false
  end

  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"
  add_index "messages", ["reciptient_id"], name: "index_messages_on_reciptient_id"

  create_table "microposts", force: true do |t|
    t.string   "content",     null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "in_reply_to"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"

  create_table "relationships", force: true do |t|
    t.integer  "follower_id", null: false
    t.integer  "followed_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: true do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "nickname",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
