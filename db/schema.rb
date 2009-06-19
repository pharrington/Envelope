# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090610162021) do

  create_table "address_types", :id => false, :force => true do |t|
    t.string "type", :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user",       :limit => 65, :null => false
  end

  add_index "contacts", ["user"], :name => "contacts_user_idx"

  create_table "contacts_address_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts_addresses", :force => true do |t|
    t.text     "address",    :null => false
    t.string   "type"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts_addresses", ["contact_id"], :name => "contacts_addresses_idx"

  create_table "contacts_email_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts_emails", :force => true do |t|
    t.string   "email",      :null => false
    t.string   "type"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts_emails", ["contact_id"], :name => "contacts_emails_idx"

  create_table "contacts_im_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts_ims", :force => true do |t|
    t.string   "handle",     :null => false
    t.string   "type"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts_ims", ["contact_id"], :name => "contacts_ims_idx"

  create_table "contacts_phone_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts_phones", :force => true do |t|
    t.string   "number",     :null => false
    t.string   "type"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts_phones", ["contact_id"], :name => "contacts_phones_idx"

  create_table "email_address_image_whitelists", :id => false, :force => true do |t|
    t.string   "email",                    :null => false
    t.string   "user_email", :limit => 65
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_address_image_whitelists", ["user_email"], :name => "index_email_address_image_whitelists_on_user_email"

  create_table "email_types", :id => false, :force => true do |t|
    t.string "type", :null => false
  end

  create_table "im_types", :id => false, :force => true do |t|
    t.string "type", :null => false
  end

  create_table "phone_types", :id => false, :force => true do |t|
    t.string "type", :null => false
  end

  create_table "settings", :id => false, :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "signature"
    t.integer  "emails_per_page"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_email",        :limit => 65, :null => false
    t.boolean  "signature_enabled"
  end

  create_table "uid_image_whitelists", :id => false, :force => true do |t|
    t.integer  "uid",                      :null => false
    t.string   "user_email", :limit => 65
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uid_image_whitelists", ["user_email"], :name => "index_uid_image_whitelists_on_user_email"

  create_table "users", :id => false, :force => true do |t|
    t.string   "email",             :limit => 65, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token",               :null => false
    t.string   "attachment_dir",    :limit => 12
  end

end
