# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 16) do

  create_table "brain_busters", :force => true do |t|
    t.string "question"
    t.string "answer"
  end

  create_table "cities", :force => true do |t|
    t.string  "name"
    t.integer "state_id"
  end

  add_index "cities", ["state_id"], :name => "index_cities_on_state_id"

  create_table "images", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string  "name"
    t.integer "top_position",  :default => 0
    t.integer "left_position", :default => 0
  end

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.string   "body"
    t.string   "name"
    t.string   "email"
    t.string   "mobile_phone"
    t.string   "land_phone"
    t.string   "resource_type"
    t.string   "properties"
    t.datetime "created_at"
    t.boolean  "subscribe_news", :default => false
    t.boolean  "urgent_contact", :default => false
  end

  create_table "properties", :force => true do |t|
    t.string   "title",                          :default => ""
    t.integer  "property_type_id"
    t.text     "desc",                           :default => "",    :null => false
    t.integer  "size",                           :default => 0
    t.string   "building_name",                  :default => "",    :null => false
    t.text     "building_desc",                  :default => "",    :null => false
    t.integer  "bedrooms",                       :default => 0
    t.integer  "bathrooms",                      :default => 0
    t.boolean  "has_pool",                       :default => false
    t.boolean  "has_fitness",                    :default => false
    t.boolean  "has_cabletv",                    :default => false
    t.boolean  "has_internet",                   :default => false
    t.integer  "parking_slots",                  :default => 0
    t.integer  "user_id"
    t.string   "image0"
    t.string   "image0_desc"
    t.string   "image1"
    t.string   "image1_desc"
    t.string   "image2"
    t.string   "image2_desc"
    t.string   "image3"
    t.string   "image3_desc"
    t.string   "image4"
    t.string   "image4_desc"
    t.string   "image5"
    t.string   "image5_desc"
    t.integer  "location_id"
    t.integer  "city_id"
    t.string   "neighbour",        :limit => 60, :default => ""
    t.text     "address"
    t.text     "contact_info"
    t.boolean  "for_sell",                       :default => false
    t.boolean  "for_rent",                       :default => false
    t.integer  "sell_price",                     :default => 0
    t.integer  "rent_price",                     :default => 0
    t.integer  "building_fees",                  :default => 0
    t.date     "available_date"
    t.date     "lease_min"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "special_tag",                    :default => false
    t.string   "permalink"
  end

  add_index "properties", ["property_type_id"], :name => "index_properties_on_property_type_id"
  add_index "properties", ["user_id"], :name => "index_properties_on_user_id"
  add_index "properties", ["location_id"], :name => "index_properties_on_location_id"
  add_index "properties", ["city_id"], :name => "index_properties_on_city_id"

  create_table "property_stats", :force => true do |t|
    t.integer  "property_id"
    t.integer  "comments_count", :default => 0
    t.integer  "page_views",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_stats", ["property_id"], :name => "index_property_stats_on_property_id"

  create_table "property_types", :force => true do |t|
    t.string "name"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",        :default => "", :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "map_image"
  end

  create_table "sitealizer", :force => true do |t|
    t.string   "path"
    t.string   "ip"
    t.string   "referer"
    t.string   "language"
    t.string   "user_agent"
    t.datetime "created_at"
    t.date     "created_on"
  end

  create_table "states", :force => true do |t|
    t.string "name"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "comments"
    t.string   "city_id"
    t.string   "country"
    t.string   "icon"
    t.boolean  "admin",                                   :default => false
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

end
