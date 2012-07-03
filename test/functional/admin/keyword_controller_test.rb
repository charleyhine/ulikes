require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/keyword_controller'

# Re-raise errors caught by the controller.
class Admin::KeywordController; def rescue_action(e) raise e end; end

class Admin::KeywordControllerTest < Test::Unit::TestCase
  fixtures :keywords

	NEW_KEYWORD = {}	# e.g. {:name => 'Test Keyword', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::KeywordController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = keywords(:first)
		@first = Keyword.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'admin/keyword/component'
    keywords = check_attrs(%w(keywords))
    assert_equal Keyword.find(:all).length, keywords.length, "Incorrect number of keywords shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'admin/keyword/component'
    keywords = check_attrs(%w(keywords))
    assert_equal Keyword.find(:all).length, keywords.length, "Incorrect number of keywords shown"
  end

  def test_create
  	keyword_count = Keyword.find(:all).length
    post :create, {:keyword => NEW_KEYWORD}
    keyword, successful = check_attrs(%w(keyword successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal keyword_count + 1, Keyword.find(:all).length, "Expected an additional Keyword"
  end

  def test_create_xhr
  	keyword_count = Keyword.find(:all).length
    xhr :post, :create, {:keyword => NEW_KEYWORD}
    keyword, successful = check_attrs(%w(keyword successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal keyword_count + 1, Keyword.find(:all).length, "Expected an additional Keyword"
  end

  def test_update
  	keyword_count = Keyword.find(:all).length
    post :update, {:id => @first.id, :keyword => @first.attributes.merge(NEW_KEYWORD)}
    keyword, successful = check_attrs(%w(keyword successful))
    assert successful, "Should be successful"
    keyword.reload
   	NEW_KEYWORD.each do |attr_name|
      assert_equal NEW_KEYWORD[attr_name], keyword.attributes[attr_name], "@keyword.#{attr_name.to_s} incorrect"
    end
    assert_equal keyword_count, Keyword.find(:all).length, "Number of Keywords should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	keyword_count = Keyword.find(:all).length
    xhr :post, :update, {:id => @first.id, :keyword => @first.attributes.merge(NEW_KEYWORD)}
    keyword, successful = check_attrs(%w(keyword successful))
    assert successful, "Should be successful"
    keyword.reload
   	NEW_KEYWORD.each do |attr_name|
      assert_equal NEW_KEYWORD[attr_name], keyword.attributes[attr_name], "@keyword.#{attr_name.to_s} incorrect"
    end
    assert_equal keyword_count, Keyword.find(:all).length, "Number of Keywords should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	keyword_count = Keyword.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal keyword_count - 1, Keyword.find(:all).length, "Number of Keywords should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	keyword_count = Keyword.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal keyword_count - 1, Keyword.find(:all).length, "Number of Keywords should be one less"
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
