ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  
  map.connect '/admin_admin', :controller => 'properties', :action => 'new'
  
  map.connect '/login', :controller => 'sessions', :action => 'new'
  map.connect '/logout', :controller => 'sessions', :action => 'destroy', :method => :delete
  
  map.connect '', :controller => 'properties'

  map.resource :session  
  map.resources :users
  map.resources :messages, :collection => {:thank_you => :get}
  map.resources :cities
  map.resources :states
  map.resources :locations
  map.resources :settings
  
  map.resources :properties, 
    :collection => {:search => :any, :map_search => :any, :cart => :get},
    :member => {:destroy_image => :post, :add_to_cart => :post, :remove_from_cart => :post}

      
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
end
