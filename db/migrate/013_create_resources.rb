class CreateResources < ActiveRecord::Migration
  def self.up
    create_table(:resources, :options => 'DEFAULT CHARSET=UTF8') do |t|
      t.column "title",           :string
      t.column "body",            :string
      t.column "name",            :string
      t.column "email",           :string
      t.column "mobile_phone",    :string
      t.column "land_phone",      :string
      t.column "resource_type",   :string
      t.column "properties",      :string
      t.column "created_at",      :datetime
      t.column "subscribe_news",  :boolean, :default => false
      t.column "urgent_contact",  :boolean, :default => false
    end
  end

  def self.down
    drop_table "resources"
  end
  
end
