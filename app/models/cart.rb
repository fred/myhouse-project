class Cart
  
  attr_reader :items
  
  def initialize
    @items = []
  end
  
  def add_item(item_id)
    if !is_in_cart(item_id)
      @items << item_id
    end
  end
  
  def delete_item(item_id)
    if is_in_cart(item_id)
      @items.delete(item_id)
    end
  end
  
  protected
  def is_in_cart(item_id)
    if @items.find {|t| t == item_id}
      return true
    else
      return false
    end
  end
  
end