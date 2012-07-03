require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

	NEW_USER = {}	# e.g. {:name => 'Test User', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = users(:first)
  end

  def test_raw_validation
    user = User.new
    if REQ_ATTR_NAMES.blank?
      assert user.valid?, "User should be valid without initialisation parameters"
    else
      # If User has validation, then use the following:
      assert !user.valid?, "User should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert user.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    user = User.new(NEW_USER)
    assert user.valid?, "User should be valid"
   	NEW_USER.each do |attr_name|
      assert_equal NEW_USER[attr_name], user.attributes[attr_name], "User.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_user = NEW_USER.clone
			tmp_user.delete attr_name.to_sym
			user = User.new(tmp_user)
			assert !user.valid?, "User should be invalid, as @#{attr_name} is invalid"
    	assert user.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_user = User.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		user = User.new(NEW_USER.merge(attr_name.to_sym => current_user[attr_name]))
			assert !user.valid?, "User should be invalid, as @#{attr_name} is a duplicate"
    	assert user.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

