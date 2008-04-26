class Property < ActiveRecord::Base
  
  before_save :strip_tags
  before_save :update_permalink
  after_save  :sweep_partial_cache
  
 # has_permalink :title
  
  has_one    :property_stat
  belongs_to :user
  belongs_to :city
  belongs_to :location
  belongs_to :property_type
  
  validates_uniqueness_of :title
  validates_presence_of :title
  
  validates_numericality_of :size, :allow_nil => true
  validates_numericality_of :bathrooms, :allow_nil => true
  validates_numericality_of :bedrooms, :allow_nil => true
  validates_numericality_of :parking_slots, :allow_nil => true
  validates_numericality_of :sell_price, :allow_nil => true
  validates_numericality_of :rent_price, :allow_nil => true
  validates_numericality_of :building_fees, :allow_nil => true


  acts_as_ferret :fields => { :title =>         {:boost => 2},
                              :desc =>          {:boost => 1}, 
                              :building_name => {:boost => 2}, 
                              :building_desc => {:boost => 1},
                              :neighbour =>     {:boost => 1},
                              :address =>       {:boost => 1},
                              :contact_info =>  {:boost => 1},
                              :city_state =>    {:boost => 3}
  }

  file_column :image0,
                :magick => {
                  :versions => {
                      :small =>   { :crop => "1:1", :geometry => "96x96", :attributes => { :quality => 90 } },
                      :medium =>  { :geometry => "240x240", :attributes => { :quality => 90 }}
                  }
  }
  file_column :image1,
                :magick => {
                  :versions => {
                      :small =>   { :crop => "1:1", :geometry => "96x96", :attributes => { :quality => 90 } },
                      :medium =>  { :geometry => "240x240", :attributes => { :quality => 90 }}
                  }
  }
  file_column :image2,
                :magick => {
                  :versions => {
                      :small =>   { :crop => "1:1", :geometry => "96x96", :attributes => { :quality => 90 } },
                      :medium =>  { :geometry => "240x240", :attributes => { :quality => 90 }}
                  }
  }
  file_column :image3,
                :magick => {
                  :versions => {
                      :small =>   { :crop => "1:1", :geometry => "96x96", :attributes => { :quality => 90 } },
                      :medium =>  { :geometry => "240x240", :attributes => { :quality => 90 }}
                  }
  }
  file_column :image4,
                :magick => {
                  :versions => {
                      :small =>   { :crop => "1:1", :geometry => "96x96", :attributes => { :quality => 90 } },
                      :medium =>  { :geometry => "240x240", :attributes => { :quality => 90 }}
                  }
  }
  file_column :image5,
                :magick => {
                  :versions => {
                      :small =>   { :crop => "1:1", :geometry => "96x96", :attributes => { :quality => 90 } },
                      :medium =>  { :geometry => "240x240", :attributes => { :quality => 90 }}
                  }
  }


  def city_state
    return "#{self.city.state.name} - #{self.city.name}"
  end
  
  def property_type_name
    return "#{self.property_type.name}"
  end
  
  def after_create
    self.property_stat = PropertyStat.new
  end
  
  def update_permalink
    self.permalink = self.id.to_s+"-"+permalink_for(self.title)
  end
    
  def permalink_for(str)
    PermalinkFu.escape(str)
  end
  
  def self.find_by_permalink(permalink)
    Property.find(:first, :condition => ["permalink = ?", permalink])
    #Property.cached(:all_properties).find {|t| t.permalink == permalink }
  end
  
  def self.featured
    Property.find(:all, 
      :limit => 4, 
      :order => 'updated_at DESC', 
      :conditions => ["special_tag = ?", true]
    )
  end

  private
  
  def sweep_partial_cache
    #cache_dir = ActionController::Base.page_cache_directory+"/.."+"/tmp/cache"
    cache_dir = RAILS_ROOT+"/tmp/cache"
    unless cache_dir == RAILS_ROOT+"/public"
      #file_name1 = cache_dir+"/*"
      file_name1 = cache_dir+"/"+self.permalink.to_s+".cache"
      file_name2 = cache_dir+"/properties/"+self.id.to_s+".cache"
      FileUtils.rm_r(Dir.glob(file_name1)) rescue Errno::ENOENT
      FileUtils.rm_r(Dir.glob(file_name2)) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Cache '#{file_name1}' delete.")
      RAILS_DEFAULT_LOGGER.info("Cache '#{file_name2}' delete.")
    end
  end
  
  def strip_tags
    self.title = strip(self.title)
    self.desc = strip(self.desc)
    self.building_name = strip(self.building_name)
    self.building_desc = strip(self.building_desc)
    self.neighbour = strip(self.neighbour)
    self.address = strip(self.address)
    self.contact_info = strip(self.contact_info)
  end
  
  # Strips all HTML tags from the input, including comments.  This uses the html-scanner
  # tokenizer and so it's HTML parsing ability is limited by that of html-scanner.      #
  # Returns the tag free text.
  def strip(html)
    if html.index("<")
      text = ""
      tokenizer = HTML::Tokenizer.new(html)
            while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        # result is only the content of any Text nodes
        text << node.to_s if node.class == HTML::Text
      end
      # strip any comments, and if they have a newline at the end (ie. line with
      # only a comment) strip that too
      text.gsub(/<!--(.*?)-->[\n]?/m, "")
    else
      html # already plain text
    end
  end
  
end



