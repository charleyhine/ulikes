require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/user_controller'

# Re-raise errors caught by the controller.
class Admin::UserController; def rescue_action(e) raise e end; end

class Admin::UserControllerTest < Test::Unit::TestCase
  fixtures :users

	NEW_USER = {}	# e.g. {:name => 'Test User', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::UserController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = users(:first)
		@first = User.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'admin/user/component'
    users = check_attrs(%w(users))
    assert_equal User.find(:all).length, users.length, "Incorrect number of users shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'admin/user/component'
    users = check_attrs(%w(users))
    assert_equal User.find(:all).length, users.length, "Incorrect number of users shown"
  end

  def test_create
  	user_count = User.find(:all).length
    post :create, {:user => NEW_USER}
    user, successful = check_attrs(%w(user successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal user_count + 1, User.find(:all).length, "Expected an additional User"
  end

  def test_create_xhr
  	user_count = User.find(:all).length
    xhr :post, :create, {:user => NEW_USER}
    user, successful = check_attrs(%w(user successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal user_count + 1, User.find(:all).length, "Expected an additional User"
  end

  def test_update
  	user_count = User.find(:all).length
    post :update, {:id => @first.id, :user => @first.attributes.merge(NEW_USER)}
    user, successful = check_attrs(%w(user successful))
    assert successful, "Should be successful"
    user.reload
   	NEW_USER.each do |attr_name|
      assert_equal NEW_USER[attr_name], user.attributes[attr_name], "@user.#{attr_name.to_s} incorrect"
    end
    assert_equal user_count, User.find(:all).length, "Number of Users should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	user_count = User.find(:all).length
    xhr :post, :update, {:id => @first.id, :user => @first.attributes.merge(NEW_USER)}
    user, successful = check_attrs(%w(user successful))
    assert successful, "Should be successful"
    user.reload
   	NEW_USER.each do |attr_name|
      assert_equal NEW_USER[attr_name], user.attributes[attr_name], "@user.#{attr_name.to_s} incorrect"
    end
    assert_equal user_count, User.find(:all).length, "Number of Users should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	user_count = User.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal user_count - 1, User.find(:all).length, "Number of Users should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	user_count = User.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal user_count - 1, User.find(:all).length, "Number of Users should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
