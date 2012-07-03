require File.dirname(__FILE__) + '/../test_helper'
require 'state'

class StateTest < Test::Unit::TestCase
  fixtures :states

  # Replace this with your real tests.
  def test_count
    assert_equal 1, State.count
  end

	def test_create_update_delete
		state = State.new( :name => 'Michigan', :abbreviation => 'CO' )
		state.save
		assert_equal 2, State.count

		state.abbreviation = 'MI'
		state.save

		state2 = State.find_by_abbreviation( 'MI' )
		assert_equal state.name, state2.name

		state.destroy
		assert_equal 1, State.count
	end
end
