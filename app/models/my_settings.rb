class MySettings < ActiveRecord::Base
  
  acts_as_cached
  after_save :reset_cache
  
  def self.get_all
    if !MySettings.cached?("all")
      settings = Settings.all
      MySettings.set_cache("all",settings)
      return self.get_cache("all")
    else
      return self.get_cache("all")
    end
  end
  
end
