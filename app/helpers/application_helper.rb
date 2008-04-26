# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def cart_items
    if session[:cart]
      Property.find(session[:cart].items)
    end
  end
  
  def yes_or_no
  end
  
  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'down' ? 'up' : 'down'
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end
  
  def has_date(date,format)
    if date != nil
      return date.to_s(format.to_sym)
    else
      return "N/A"
    end
  end
  
  def url_for_items(id)
    url_for :controller => "rss_feed_items", :action => "read", :id => id
  end

  def unread_color(bol)
    if bol
      return "blue"
    else
      return "green"
    end
  end
  
  def no_image
    "No Image"
  end
  
  def yes_or_no(bol, result)
    if bol 
      return image_tag("/images/yes.png").to_s + result.to_s
    else
      #return image_tag("/images/no.png")
      return ""
    end
  end
  
  def boolean_to_image(bol)
    if bol 
      return image_tag("/images/yes.png")
    else
      #return image_tag("/images/no.png")
      return ""
    end
  end
  
  def boolean_to_word(bol)
    if bol 
      return "Yes"
    else
      return "No"
    end
  end
  
  # if true, returns  image_tag("/images/yes.png")
  def boolean_to_image(bol)
    if bol 
      return image_tag("/images/yes.png")
    else
      #return image_tag("/images/no.png")
      return ""
    end
  end
     
end
