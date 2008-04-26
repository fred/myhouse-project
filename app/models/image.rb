class Image < ActiveRecord::Base
  
  #belongs_to :property
  
  has_attachment  :storage => :files_ystem,
    :content_type => :image, 
    :max_size => 1.megabyte,
    :thumbnails => { :small => '96x96>', :medium => '240x240>' },
    :processor => :MiniMagick
  
  validates_as_attachment
  
end
