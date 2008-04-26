require "rubygems"
require 'test/unit'
require 'ostruct'

require 'active_support'
require 'action_pack'
require 'action_controller'
require 'action_view'

require File.dirname(__FILE__) + '/../lib/text_area_with_status'

# A quick and dirty mock object
class MyMock
  def id() 17 end
  def description() 'hello' end
end

class TextAreaWithStatusTest < Test::Unit::TestCase
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper
  
  include TextAreaWithStatus

  require File.dirname(__FILE__) + '/../init'

  # Expected results
  ResPlainArea1      = "<textarea cols=\"40\" id=\"thing_description\" name=\"thing[description]\" rows=\"20\">hello</textarea>"
  ResPlainArea2      = "<textarea id=\"description\" name=\"description\"></textarea>"

  ResAreaWithStatus1 = "<textarea cols=\"40\" id=\"thing_description\" name=\"thing[description]\" onkeyup=\"limit_chars(this, 10, $('c_left_my_mock_description_17'), 'You have %d characters left.')\" rows=\"20\">hello</textarea><br />\n<span id=\"c_left_my_mock_description_17\">You have 5 characters left.</span>"
  ResAreaWithStatus2 = "<textarea cols=\"40\" id=\"thing_description\" name=\"thing[description]\" onkeyup=\"limit_chars(this, 20, $('c_left_my_mock_description_17'), 'Left chars: %d')\" rows=\"20\">hello</textarea><br />\n<span id=\"c_left_my_mock_description_17\">Left chars: 15</span>"
  ResAreaWithStatus3 = "<textarea cols=\"40\" id=\"rails_fu_17\" name=\"thing[description]\" onkeyup=\"limit_chars(this, 99, $('c_left_my_mock_description_17'), 'Rails-Fu Magic No. #%d')\" rows=\"20\">hello</textarea><br />\n<span id=\"c_left_my_mock_description_17\">Rails-Fu Magic No. #94</span>"
  ResAreaWithStatus4 = "<textarea id=\"description\" name=\"description\" onkeyup=\"limit_chars(this, 10, $('c_description_left'), 'You have %d characters left.')\"></textarea><br />\n<span id=\"c_description_left\">You have 10 characters left.</span>"
  ResAreaWithStatus5 = "<textarea id=\"description\" name=\"description\" onkeyup=\"limit_chars(this, 20, $('c_description_left'), 'Left chars: %d')\"></textarea><br />\n<span id=\"c_description_left\">Left chars: 20</span>"
  ResAreaWithStatus6 = "<textarea id=\"description\" name=\"description\" onkeyup=\"limit_chars(this, 10, $('c_description_left'), 'You have %d characters left.')\">abcd</textarea><br />\n<span id=\"c_description_left\">You have 6 characters left.</span>"
  ResAreaWithStatus7 = "<textarea id=\"description\" name=\"description\" onkeyup=\"limit_chars(this, 20, $('c_description_left'), 'Left chars: %d')\">abc</textarea><br />\n<span id=\"c_description_left\">Left chars: 17</span>"
  ResAreaWithStatus8 = "<textarea id=\"rails_fu_17\" name=\"description\" onkeyup=\"limit_chars(this, 99, $('rails_fu_17_left'), 'Rails-Fu Magic No. #%d')\">abcde</textarea><br />\n<span id=\"rails_fu_17_left\">Rails-Fu Magic No. #94</span>"

  def setup
    @controller = OpenStruct.new
    @controller.request = OpenStruct.new
    @thing = MyMock.new
  end

  def test_defaults_include_plugins_js
    assert javascript_include_tag(:defaults) =~ /limit_chars.js/, "javascript_include_tag(:defaults) should include limit_chars.js"
  end

  def test_text_area_with_status
    # Let's make sure the _without versions works ok in absence of our custom options
    assert_equal ResPlainArea1, text_area(:thing, :description)

    # Now let's test it with our options included
    assert_equal ResAreaWithStatus1, text_area(:thing, :description, :max_chars => 10)
    assert_equal ResAreaWithStatus2, text_area(:thing, :description, :max_chars => 20, :max_chars_msg => 'Left chars: %d')
    assert_equal ResAreaWithStatus3, text_area(:thing, :description, :max_chars => 99, :id => 'rails_fu_17', :max_chars_msg => 'Rails-Fu Magic No. #%d')
  end

  def test_text_area_with_status_and_form_builder
    f = ActionView::Helpers::FormBuilder.new(:thing, @thing, ActionView::Base.new, nil, nil)

    # Let's make sure the _without versions works ok in absence of our custom options
    assert_equal ResPlainArea1, f.text_area(:description)

    # Now let's test it with our options included
    assert_equal ResAreaWithStatus1, f.text_area(:description, :max_chars => 10)
    assert_equal ResAreaWithStatus2, f.text_area(:description, :max_chars => 20, :max_chars_msg => 'Left chars: %d')
    assert_equal ResAreaWithStatus3, f.text_area(:description, :max_chars => 99, :id => 'rails_fu_17', :max_chars_msg => 'Rails-Fu Magic No. #%d')
  end

  def test_text_area_tag_with_status
    # Let's make sure the _without versions works ok in absence of our custom options
    assert_equal ResPlainArea2, text_area_tag('description')

    # Now let's test it with our options included
    assert_equal ResAreaWithStatus4, text_area_tag('description',     nil, :max_chars => 10)
    assert_equal ResAreaWithStatus5, text_area_tag('description',     nil, :max_chars => 20, :max_chars_msg => 'Left chars: %d')
    assert_equal ResAreaWithStatus6, text_area_tag('description',  "abcd", :max_chars => 10)
    assert_equal ResAreaWithStatus7, text_area_tag('description',   "abc", :max_chars => 20, :max_chars_msg => 'Left chars: %d')
    assert_equal ResAreaWithStatus8, text_area_tag('description', "abcde", :max_chars => 99, :id => 'rails_fu_17', :max_chars_msg => 'Rails-Fu Magic No. #%d')
  end

end
