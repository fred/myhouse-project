class MessagesController < ApplicationController

  layout 'realstate'

  before_filter :admin, :except => [ :new, :create ]

  # GET /messages
  # GET /messages.xml
  def index
    order = "id DESC"
    per_page = 50
    current_page = (params[:page] ||= 1).to_i
    @messages = Message.paginate :page => current_page, :per_page => per_page, :order => order
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    @message.properties = session[:cart].items
    respond_to do |format|
      if @message.save
        flash[:notice] = "Your message was send successfuly."
        format.html { redirect_to url_for(:action => :thank_you) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def thank_you
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = "Message was updated."
        format.html { redirect_to message_path(@message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_path }
      format.xml  { head :ok }
    end
  end

  protected
  def admin
    unless logged_id?
      redirect_to new_message_path
    end
  end
  def logged_id?
    current_user != :false
  end

end

