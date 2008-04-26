class Message < ActiveRecord::Base
  
  #validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_presence_of :name, :email
  
  require "yaml"
  
  def items_count
   if items=self.items
      items.length
    else
      return 0
    end
  end
  
  def items
    if self.properties
       YAML::load(self.properties)
     else
       return nil
    end
  end
  
  def properties_array
    if property = self.items
      array = []
      property.each do |t|
        array << Property.find(t)
      end
      array
    else
      return []
    end
  end
  
end

