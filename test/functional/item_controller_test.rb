require File.dirname(__FILE__) + '/../test_helper'
require 'index_controller'

# Re-raise errors caught by the controller.
class IndexController; def rescue_action(e) raise e end; end

class IndexControllerTest < Test::Unit::TestCase
  fixtures :items

  def setup
    @controller = IndexController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = items(:first).id
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

    assert_not_nil assigns(:items)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:item)
    assert assigns(:item).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:item)
  end

  def test_create
    num_items = Item.count

    post :create, :item => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_items + 1, Item.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:item)
    assert assigns(:item).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Item.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Item.find(@first_id)
    }
  end
end
