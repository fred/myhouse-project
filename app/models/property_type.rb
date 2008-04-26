class PropertyType < ActiveRecord::Base
  
  has_many :properties
  
  validates_presence_of :name
  
end
