class AddVoteCountToItem < ActiveRecord::Migration
  def self.up
    #this is a deliberate denormailization to speed the app up
    add_column(:items, :vote_count, :integer)
  end

  def self.down
  end
end
