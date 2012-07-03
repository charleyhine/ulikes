require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < Test::Unit::TestCase
  fixtures :items

	NEW_ITEM = {}	# e.g. {:name => 'Test Item', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = items(:first)
  end

  def test_raw_validation
    item = Item.new
    if REQ_ATTR_NAMES.blank?
      assert item.valid?, "Item should be valid without initialisation parameters"
    else
      # If Item has validation, then use the following:
      assert !item.valid?, "Item should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert item.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    item = Item.new(NEW_ITEM)
    assert item.valid?, "Item should be valid"
   	NEW_ITEM.each do |attr_name|
      assert_equal NEW_ITEM[attr_name], item.attributes[attr_name], "Item.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_item = NEW_ITEM.clone
			tmp_item.delete attr_name.to_sym
			item = Item.new(tmp_item)
			assert !item.valid?, "Item should be invalid, as @#{attr_name} is invalid"
    	assert item.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_item = Item.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		item = Item.new(NEW_ITEM.merge(attr_name.to_sym => current_item[attr_name]))
			assert !item.valid?, "Item should be invalid, as @#{attr_name} is a duplicate"
    	assert item.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

