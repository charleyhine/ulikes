require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/segment_controller'

# Re-raise errors caught by the controller.
class Admin::SegmentController; def rescue_action(e) raise e end; end

class Admin::SegmentControllerTest < Test::Unit::TestCase
  fixtures :segments

	NEW_SEGMENT = {}	# e.g. {:name => 'Test Segment', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::SegmentController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = segments(:first)
		@first = Segment.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'admin/segment/component'
    segments = check_attrs(%w(segments))
    assert_equal Segment.find(:all).length, segments.length, "Incorrect number of segments shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'admin/segment/component'
    segments = check_attrs(%w(segments))
    assert_equal Segment.find(:all).length, segments.length, "Incorrect number of segments shown"
  end

  def test_create
  	segment_count = Segment.find(:all).length
    post :create, {:segment => NEW_SEGMENT}
    segment, successful = check_attrs(%w(segment successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal segment_count + 1, Segment.find(:all).length, "Expected an additional Segment"
  end

  def test_create_xhr
  	segment_count = Segment.find(:all).length
    xhr :post, :create, {:segment => NEW_SEGMENT}
    segment, successful = check_attrs(%w(segment successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal segment_count + 1, Segment.find(:all).length, "Expected an additional Segment"
  end

  def test_update
  	segment_count = Segment.find(:all).length
    post :update, {:id => @first.id, :segment => @first.attributes.merge(NEW_SEGMENT)}
    segment, successful = check_attrs(%w(segment successful))
    assert successful, "Should be successful"
    segment.reload
   	NEW_SEGMENT.each do |attr_name|
      assert_equal NEW_SEGMENT[attr_name], segment.attributes[attr_name], "@segment.#{attr_name.to_s} incorrect"
    end
    assert_equal segment_count, Segment.find(:all).length, "Number of Segments should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	segment_count = Segment.find(:all).length
    xhr :post, :update, {:id => @first.id, :segment => @first.attributes.merge(NEW_SEGMENT)}
    segment, successful = check_attrs(%w(segment successful))
    assert successful, "Should be successful"
    segment.reload
   	NEW_SEGMENT.each do |attr_name|
      assert_equal NEW_SEGMENT[attr_name], segment.attributes[attr_name], "@segment.#{attr_name.to_s} incorrect"
    end
    assert_equal segment_count, Segment.find(:all).length, "Number of Segments should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	segment_count = Segment.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal segment_count - 1, Segment.find(:all).length, "Number of Segments should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	segment_count = Segment.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal segment_count - 1, Segment.find(:all).length, "Number of Segments should be one less"
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
