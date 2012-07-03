class AddYahooLocalIdToItem < ActiveRecord::Migration
  def self.up
    add_column(:items, :yahoo_local_id, :integer)
  end

  def self.down
  end
end
