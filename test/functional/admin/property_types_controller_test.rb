require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/property_types_controller'

# Re-raise errors caught by the controller.
class Admin::PropertyTypesController; def rescue_action(e) raise e end; end

class Admin::PropertyTypesControllerTest < Test::Unit::TestCase
  fixtures :property_types

  def setup
    @controller = Admin::PropertyTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = property_types(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:property_types)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:property_type)
    assert assigns(:property_type).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:property_type)
  end

  def test_create
    num_property_types = PropertyType.count

    post :create, :property_type => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_property_types + 1, PropertyType.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:property_type)
    assert assigns(:property_type).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      PropertyType.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PropertyType.find(@first_id)
    }
  end
end
