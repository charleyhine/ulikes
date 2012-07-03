class AddQueryCaching < ActiveRecord::Migration
  def self.up
    create_table "queries", :force => true do |t|
      t.column "query_text",    :string, :limit => 80
      t.column "location_text", :string, :limit => 80
      t.column "city_id", :integer
      t.column "state_id", :integer
      t.column "created_on",   :datetime
      t.column "updated_on",   :datetime
    end

    create_table "items_queries", :force => true do |t|
      t.column "query_id", :integer
      t.column "item_id", :integer
      t.column "created_on",   :datetime
      t.column "updated_on",   :datetime
    end
  end

  def self.down
    drop_table "queries"
    drop_table "items_queries"
  end
end
