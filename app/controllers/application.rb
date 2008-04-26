# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'e139ac47016bc19d3d35f5cd42253752'
  
  # Be sure to include Authentication
  include AuthenticatedSystem
  
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie, :load_settings, :find_cart
  
  def load_settings
    session[:settings_unit] ||= Settings.unit
  end
  
  def find_cart
    session[:cart] ||= Cart.new
  end


end
