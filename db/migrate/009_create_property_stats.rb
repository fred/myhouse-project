class CreatePropertyStats < ActiveRecord::Migration
  
  def self.up
    create_table(:property_stats, :options => 'DEFAULT CHARSET=UTF8', :force => true) do |t|
      t.column :property_id,    :integer
      t.column :comments_count, :integer, :default => 0
      t.column :page_views,     :integer, :default => 0
      t.column :created_at,     :datetime
      t.column :updated_at,     :datetime
    end  
    add_index :property_stats, [:property_id]
  end

  def self.down
    drop_table :property_stats
    #remove_index :property_stats, [:property_id]
  end
end
