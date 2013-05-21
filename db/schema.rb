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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130516194438) do

  create_table "drive_files", :force => true do |t|
    t.integer  "drive_user_id"
    t.string   "file_id"
    t.string   "download_link"
    t.string   "name"
    t.string   "fileType"
    t.string   "description"
    t.float    "size"
    t.string   "path"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "drive_users", :force => true do |t|
    t.string   "display_name"
    t.float    "quota_total"
    t.float    "quota_used"
    t.float    "quota_trash"
    t.string   "root_id"
    t.string   "picture"
    t.string   "name"
    t.string   "access_token"
    t.integer  "uid"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
  end

  create_table "dropbox_files", :force => true do |t|
    t.integer  "dropbox_user_id"
    t.string   "file_path"
    t.boolean  "directory"
    t.string   "rev"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "size"
    t.string   "name"
    t.string   "fileType"
    t.integer  "origin"
    t.string   "folder_hash"
    t.string   "ancestry"
  end

  add_index "dropbox_files", ["ancestry"], :name => "index_dropbox_files_on_ancestry"

  create_table "dropbox_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "referral_link"
    t.string   "display_name"
    t.integer  "uid"
    t.string   "country"
    t.float    "quota_normal"
    t.float    "quota_shared"
    t.float    "quota_total"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "access_token_key"
    t.string   "access_token_secret"
    t.string   "name"
    t.string   "root_hash"
  end

  create_table "dropboxes", :force => true do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.string   "referral_link"
    t.string   "display_name"
    t.integer  "uid"
    t.string   "country"
    t.float    "quota_normal"
    t.float    "quota_shared"
    t.float    "quota_total"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

end
