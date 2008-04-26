class AddPropertyPermalink < ActiveRecord::Migration
  def self.up
    add_column "properties", "permalink", :string
    
    Property.find(:all).each do |prop|
      prop.update_attribute :permalink, PermalinkFu.escape(prop.title)
    end
        
  end

  def self.down
    remove_column "properties", "permalink"
  end
end
