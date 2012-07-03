class Query < ActiveRecord::Base
  has_and_belongs_to_many :items, :join_table => "items_queries", :order => ' vote_count, name desc'
  belongs_to :city
  belongs_to :state

  validates_presence_of :query_text, :location_text, :city, :state
  validates_length_of :query_text, :minimum => 2

  #location_text has to be at least as long as a zipcode
  validates_length_of :location_text, :minimum => 5 

  def execute 
    if !self.query_text.nil? && !self.location_text.nil?
      lookup = YahooLocalV2.new(self.query_text, self.location_text, self.items.count + 1, 20)
      results = lookup.search()
      for result in results
        if !self.items.include?(result)
          self.items << result
        end
      end
      self.city = lookup.city
      self.state = lookup.state
    end
  end

  def Query.find_or_create(query_text, location)
    #normalize the query data a bit
    query_text.gsub!(/\s+/, ' ')
    query_text.gsub!(/(^\s+|\s+$)/, '')
    location.gsub!(/(^\s+|\s+$)/, '')
    location.gsub!(/\s+$/, '')

    query = Query.find(:first, 
                       :conditions => ["query_text = ? and location_text = ?", 
                           query_text.upcase,
                           location.upcase]
                      )
    if query.nil?
      query = Query.new(:query_text => query_text.upcase, 
                        :location_text => location.upcase)
    end
    #execute the query, which gets initial results or more results
    #artificial limit of 150 results for a single query
    if query.items.count < 150
      query.execute()
      query.save
    end
    return query
  end
end
