class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table(:properties, :options => 'DEFAULT CHARSET=UTF8') do |t|              
        # Properties  
        t.column "title",           :string,  :default => ""
        t.column "property_type_id",:integer
        t.column "desc",            :text,    :default => "", :null => false
        t.column "size",            :integer, :default => 0
        t.column "building_name",   :string,  :default => "", :null => false
        t.column "building_desc",   :text,    :default => "", :null => false
        t.column "bedrooms",        :integer, :default => 0
        t.column "bathrooms",       :integer, :default => 0
        t.column "has_pool",        :boolean, :default => false
        t.column "has_fitness",     :boolean, :default => false
        t.column "has_cabletv",     :boolean, :default => false
        t.column "has_internet",    :boolean, :default => false
        t.column "parking_slots",   :integer, :default => 0
        t.column "user_id",         :integer
        # images
        t.column "image0",          :string
        t.column "image0_desc",     :string
        t.column "image1",          :string
        t.column "image1_desc",     :string
        t.column "image2",          :string
        t.column "image2_desc",     :string
        t.column "image3",          :string
        t.column "image3_desc",     :string
        t.column "image4",          :string
        t.column "image4_desc",     :string
        t.column "image5",          :string
        t.column "image5_desc",     :string
        # location
        t.column "location_id",     :integer
        t.column "city_id",         :integer
        t.column "neighbour",       :string,  :limit => 60, :default => ""
        t.column "address",         :text,    :default => ""
        t.column "contact_info",    :text,    :default => ""
        # rent/sell values
        t.column "for_sell",        :boolean, :default => false
        t.column "for_rent",        :boolean, :default => false
        t.column "sell_price",      :integer, :default => 0
        t.column "rent_price",      :integer, :default => 0
        t.column "building_fees",   :integer, :default => 0
        #dates
        t.column "available_date",  :date
        t.column "lease_min",       :date
        t.column "created_at",      :datetime
        t.column "updated_at",      :datetime
    end
    # Not required, but should help more than it hurts
    add_index :properties, [:property_type_id]
    add_index :properties, [:user_id]
    add_index :properties, [:location_id]
    add_index :properties, [:city_id]
  end

  def self.down
    drop_table :properties
  end

end
