class City < ActiveRecord::Base
  
  has_many :properties
  belongs_to :state
  
  validates_presence_of :name
  
  def full_name
    return "#{self.state.name} - #{self.name}"
  end
  
end
