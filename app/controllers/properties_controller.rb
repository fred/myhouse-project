class PropertiesController < ApplicationController
  
  before_filter :login_required, :except => [ :index, :show, :search, :map_search, :add_to_cart, :delete_from_cart ]
  
  before_filter :get_extras, :only => [:new, :edit, :create, :update]
  before_filter :sort_links, :only => [:index, :search, :map_search ]

  layout 'realstate'
  
  # GET /properties
  # GET /properties.xml
  def index
    per_page = 8
    current_page = (params[:page] ||= 1).to_i
    
    if params[:c]
      @column_name = case params[:c]
        when "rent_price" then "properties.rent_price"
        when "sell_price" then "properties.sell_price"
        when "location"   then "properties.location_id"
        when "city"       then "properties.city_id"
        when "state"      then "properties.state_id"
        when "neighbour"  then "properties.neighbour"
        when "bedrooms"   then "properties.bedrooms"
        when "bathrooms"  then "properties.bathrooms"
        when "size"       then "properties.size"
      else "properties.id DESC"
    end
      order = @column_name + (params[:d] == 'down' ? ' DESC' : ' ASC')
    else
      order = "properties.id DESC"
    end
   
    @properties = Property.paginate :page => current_page, :per_page => per_page, :order => order

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @properties.to_xml }
    end
  end

  # GET /properties/1
  # GET /properties/1.xml
  def show
   @property = Property.find(params[:id], :include => [:city,:property_type,:location,:property_stat])
   respond_to do |format|
     format.html # show.rhtml
     format.xml  { render :xml => @property.to_xml }
   end
   rescue
     flash[:notice] = "Sorry, Property not available."
     redirect_to properties_path
  end

   # GET /properties/new
   def new
     @property = Property.new
   end


   # GET /properties/1;edit
   def edit
     @property = Property.find(params[:id])
   end

   # POST /properties
   # POST /properties.xml
   def create
     @property = Property.new(params[:property])

     respond_to do |format|
       if @property.save
         flash[:notice] = 'Property was successfully created.'
         format.html { redirect_to property_url(@property) }
         format.xml  { head :created, :location => property_url(@property) }
       else
         format.html { render :action => "new" }
         format.xml  { render :xml => @property.errors.to_xml }
       end
     end
   end

   # PUT /properties/1
   # PUT /properties/1.xml
   def update
     @property = Property.find(params[:id])

     respond_to do |format|
       if @property.update_attributes(params[:property])
         flash[:notice] = 'Property was successfully updated.'
         format.html { redirect_to property_url(@property) }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @property.errors.to_xml }
       end
     end
   end

   # DELETE /properties/1
   # DELETE /properties/1.xml
   def destroy
     @property = Property.find(params[:id])
     @property.destroy

     respond_to do |format|
       format.html { redirect_to properties_url }
       format.xml  { head :ok }
     end
   end


   def destroy_image
     property = Property.find(params[:id])
     property[params[:image].to_sym] = nil
     if property.save
       flash[:notice] = "#{params[:image]} removed"
       redirect_to :action => 'show', :id => params[:id]
     end
   rescue
       flash[:notice] = "There was an error, #{params[:image]} was not removed."
       redirect_to :action => 'show', :id => params[:id]
   end


   def map_search
     @locations=Location.find(:all)
     if params[:search]
       location_array = params[:search]
       current_page = (params[:page] ||= 1).to_i 
       per_page = 8
       @locations_requested = Location.find(location_array)
       conditions = ["location_id in (?)", location_array ]

       @properties = Property.paginate :page => current_page, 
        :per_page => per_page,
        :include => [:property_type,:location,:city],
        :conditions => conditions
     end
   end

   def search
     #@locations = Location.find(:all)
     #@cities = City.find(:all, :include => :state)
     blank_values = 0

     if params[:rent_price] && params[:rent_price] != ""
       rent_price = params[:rent_price].to_i
       rent_price_high = rent_price*1.25
       rent_price_low  = rent_price*0.75
       blank_values += 1
     else
       rent_price_high = 999999999
       rent_price_low  = 0
     end

     if params[:sell_price] && params[:sell_price] != ""
       sell_price = params[:sell_price].to_i
       sell_price_high = sell_price*1.25
       sell_price_low  = sell_price*0.75
       blank_values += 1
     else
       sell_price_high = 999999999
       sell_price_low  = 0
       #max=2147483647
     end

     if params[:size] && params[:size] != ""
       size = params[:size].to_i
       size_high = size*1.25
       size_low  = size*0.75
       blank_values += 1
     else
       size_high = 999999999
       size_low  = 0
     end

     #if params[:search] && params[:search][:city_ids]
       #@city_ids = params[:search][:city_ids].to_a
     #else
       #@city_ids = @cities.collect {|p| p.id }
     #end

     if params[:bedrooms] && params[:bedrooms] != ""
       bedrooms_low   = params[:bedrooms]
       bedrooms_high  = params[:bedrooms]
       blank_values += 1
     else
       bedrooms_low   = 0
       bedrooms_high  = 99
     end

     if params[:bathrooms] && params[:bathrooms] != ""
       bathrooms_low   = params[:bathrooms]
       bathrooms_high  = params[:bathrooms]
       blank_values += 1
     else
       bathrooms_low  = 0
       bathrooms_high = 99
     end

     if blank_values != 0
       per_page = 10
       order = "id DESC"
       current_page = (params[:page] ||= 1).to_i
       conditions = ["(sell_price BETWEEN ? and ?) AND (rent_price BETWEEN ? and ?) AND (size BETWEEN ? and ?) AND (bedrooms BETWEEN ? and ?) AND (bathrooms BETWEEN ? and ?)", 
         sell_price_low, sell_price_high, rent_price_low, rent_price_high, size_low, size_high, bedrooms_low, bedrooms_high, bathrooms_low, bathrooms_high]

       @properties = Property.paginate :page => current_page, 
         :per_page => per_page, 
         :order => order,
         :conditions => conditions
       ### Using cached objects example
       #@properties = Property.get_cache(:all_properties).find_all {|t| t.sell_price.between?(sell_price_low,sell_price_high)}
     else
       flash[:notice] = "You haven't typed anything" if params[:search]
     end
   end  

   def add_to_cart
     @cart = find_cart
     property = Property.find(params[:id])
     #property = Property.get_cache(:all_properties).find { |t| t.id == (params[:id])}
     @cart.add_item(property.id)
     redirect_back_or_default("/")
   rescue
     redirect_back_or_default("/")
   end

   def delete_from_cart
     @cart = find_cart
     property = Property.find(params[:id])
     #property = Property.get_cache(:all_properties).find { |t| t.id == (params[:id])}
     @cart.delete_item(property.id)
     redirect_back_or_default("/")
   rescue
     redirect_back_or_default("/")
   end

   def cart
     @cart = find_cart
   end

  
  private
  
  def sort_links
    @sort_links = [
      { :title => _("Rent Price"), :name => "rent_price" },
      { :title => _("Sell Price"), :name => "sell_price" },
      { :title => _("Location"), :name => "location" },
      { :title => _("Bedrooms"), :name => "size" },
      { :title => _("Bathrooms"), :name => "size" },
      #{ :title => "Neighbour", :name => "neighbour" },
      #{ :title => "City", :name => "city" },
      #{ :title => "State", :name => "state" },
      { :title => _("Size"), :name => "size" }
    ]
  end
    
  def sweep_session
    session[:featured_properties] = nil
  end
  
  def get_extras
    @cities = City.find(:all)
    @locations = Location.find(:all)
    @property_types = PropertyType.find(:all)
  end
  
  def admin
    unless logged_id?
      redirect_to properties_path
    end
  end
  
  def logged_id?
    current_user != :false
  end
  
  def increment_show_counter(property)
    property.property_stat.page_views += 1
    if property.property_stat.save!
      return true
    end
  end
  
end

