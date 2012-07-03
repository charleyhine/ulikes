class Item < ActiveRecord::Base
	belongs_to :keyword
	belongs_to :city
	belongs_to :state
	belongs_to :zipcode
	belongs_to :segment

  #TODO: create an before_save method to keep city.state and item.state in sync
  #or remove item.state

	validates_presence_of :name
	validates_length_of :name, :minimum => 3 
	#validates_length_of :description, :minimum => 1 
  #
  def name_with_location
    return "#{self.name} in #{self.city.name}, #{self.state.abbreviation}"
  end

	# creates a new instance of a subclass of Item using a :type parameter
	def Item.factory( params = nil )
		if !params.nil? && !params[:type].nil? && !params[:type].empty?
			instance = params[:type].constantize.new(params)
			if !instance.kind_of? Item
				raise ArgumentError(":type must be a subclass of Item.")
			end
			return instance
		end	
		return Item.new( params )
	end

  # this should be changed to properly use the subclasses
  # not all Items have latitude and longitudes
	def Item.find_existing(name, latitude, longitude)
		item = Item.find(:first,
              :conditions => { 
								:name => name, 
								:latitude => latitude, 
								:longitude => longitude
							}
						 )
		#if !item.nil? && item.keyword.nil 
		#	item.keyword = Keyword.generate(@item)
		#	item.save
		#end
		return item
	end

  def Item.find_by_query(query, offset, size)
    item = Item.find(:all,
                    :joins => "INNER JOIN items_queries ON item_id = items.id",
                    :conditions => ["query_id = ?", query.id],
                    :offset => offset,
                    :limit => size,
                    :order => ' vote_count desc, name asc')
    return item
  end

  def Item.extract_item_from_text(msg_text)
    vote_item = nil
    words = msg_text.split(/@/)
    if words.size >= 2
      item_name = words[0].strip
      log.debug("Item Name: #{item_name}")
      city = City.find_from_text(words[1]) 
      log.debug("City: #{city.name}")
      return nil if city.nil?

      vote_item = Item.find(:first, 
                       :conditions => 
                          ["upper(name) = ? and city_id = ?", item_name.upcase, city.id])

      if vote_item.nil?
        query = Query.find_or_create(item_name, 
          "#{city.name}, #{city.state.abbreviation}")
      
        if query.items.count == 1
          vote_item = query.items[0]
        else
          #find all the items that match the input
          log.debug("Query Items: #{query.items.size}")
          items = query.items.select do |i| 
            i.name.gsub(/[^A-Z|a-z|0-9| ]/,'').upcase.include?(item_name.gsub(/[^A-Z|a-z|0-9| ]/,'').upcase) 
          end
          if items.size == 1
            vote_item = items[0]
          end
        end
      end
    end
    return vote_item
  end

  #get the top 10 vote getting items from the db
	#only returns certain fields from the items table
	def Item.find_top_ten
		sql =  "select items.id, " 
    sql << " items.name, items.vote_count, cities.name as city_name, "
    sql << "states.abbreviation as state_abbrev "
		sql << "from items "
		sql << "inner join cities "
		sql << "	on items.city_id = cities.id "
		sql << "inner join states "
		sql << "	on items.state_id = states.id "
		sql << "order by items.vote_count desc limit 10;"

		#load these by hand because we want the vote_count property
		items = Array.new
		results = self.connection.select_all(sql)
		for result in results
			item = Item.new(:name => result["name"], :vote_count => result["vote_count"])
			item.city = City.new(:name => result["city_name"])
			item.state = State.new(:abbreviation => result["state_abbrev"])
			item.id = result["id"]
			items.push(item)
		end
		return items
	end

	#get items that most recently were created
	#only returns certain fields from the items table
	def Item.find_recent_items()
		sql =  "select items.id, " 
    sql << " items.name, items.vote_count, cities.name as city_name, "
    sql << "states.abbreviation as state_abbrev "
		sql << "from items "
		sql << "inner join cities "
		sql << "	on items.city_id = cities.id "
		sql << "inner join states "
		sql << "	on items.state_id = states.id "
    sql << "inner join keywords "
    sql << " on items.keyword_id = keywords.id "
		sql << "order by keywords.created_on desc limit 10;"

		items = Array.new
		results = self.connection.select_all(sql)
		for result in results
			item = Item.new(:name => result["name"], :vote_count => result["vote_count"])
			item.city = City.new(:name => result["city_name"])
			item.state = State.new(:abbreviation => result["state_abbrev"])
			item.id = result["id"]
			items.push(item)
		end
		return items
	end

	#get the most recently voted on items
	#only returns certain fields from the items table
	def Item.find_recently_voted
		sql =  "select items.id, " 
    sql << " items.name, items.vote_count, cities.name as city_name, "
    sql << "states.abbreviation as state_abbrev "
		sql << "from items "
		sql << "inner join votes "
		sql << "	on votes.item_id = items.id "
		sql << "inner join cities "
		sql << "	on items.city_id = cities.id "
		sql << "inner join states "
		sql << "	on items.state_id = states.id "
		sql << "order by votes.created_on desc limit 10;"

		items = Array.new
		results = self.connection.select_all(sql)
		for result in results
			item = Item.new(:name => result["name"], :vote_count => result["vote_count"])
			item.city = City.new(:name => result["city_name"])
			item.state = State.new(:abbreviation => result["state_abbrev"])
			item.id = result["id"]
			items.push(item)
		end
		return items
	end

end
