class RemoveIdFromItemsQueries < ActiveRecord::Migration
  def self.up
    #this table should not have an id because it is a join table
    remove_column(:items_queries, :id)
  end

  def self.down
  end
end
