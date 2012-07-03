class Keyword < ActiveRecord::Base
    
	#Active Record stuff
	has_one :item
	before_save :upcase_value

	validates_presence_of :value
	validates_uniqueness_of :value
	validates_format_of :value, :with => /^[a-z]{3,6}\d*$/i, 
		:message => "invalid (eg: DAM123)"

	def Keyword.handle(conversation)

		#get the first word of the message
		to_find = conversation.current_message.data.split[0]
		to_find.upcase!

		log.debug("Trying to find keyword for: #{to_find}")
		keyword = Keyword.find_by_value(to_find) 

		if keyword.nil?
			#go to next step in processor
			if !Keyword.successor.nil?
				Keyword.successor.handle(conversation)
			end
		else
			log_handle(Keyword, conversation)

			item = keyword.item
			item_text = "'#{item.name}' in #{item.city.name}, #{item.state.abbreviation}"

      Vote.cast_and_respond(item, conversation)

			step = KeywordStep.new( :keyword => keyword, 
															:message => conversation.current_message )
			conversation.steps << step
			conversation.state = ConversationState::CLOSED
			conversation.save
		end
	end

	def Keyword.generate(item)
		new_keyword = ""
		if item.nil? || item.name.nil? || item.name.length < 3
			return nil
		end

		#remove unwanted characters
    item_name = String.new(item.name)
    item_name.gsub!("0", "zero")
    item_name.gsub!("1", "one")
    item_name.gsub!("2", "two")
    item_name.gsub!("3", "three")
    item_name.gsub!("4", "four")
    item_name.gsub!("5", "five")
    item_name.gsub!("6", "six")
    item_name.gsub!("7", "seven")
    item_name.gsub!("8", "eight")
    item_name.gsub!("9", "nine")
    item_name.gsub!(/([^A-Z])/i ,"")
		item_name.upcase!
    puts item_name

		#see if the item name can be split into 3 parts
		#then generate an "acronym" if it can
		#otherwise just use the first 3 or 4 letters of the item's name
		parts = item_name.split
		puts parts.inspect
		if parts.size >= 3
			for i in 0...3
			    # take the first letter
				new_keyword = new_keyword + parts[i].split(//)[0]
			end
		elsif item_name.length >= 3 
		    new_keyword = item_name[0,3]
		elsif item_name.length >= 4 
			new_keyword = item_name[0,4]
		end

    puts new_keyword
		#log.debug("Generate Keyword: #{new_keyword}")
		keyword = Keyword.find_by_value(new_keyword)

    #this adds the city's initials if the keyword/item_name exist then
    #allows for up to 11 keywords per three letter combination
		#then it moves to the next closest letters in the alphabet
    if keyword != nil && Item.exists?(:name => item.name)
      the_city = City.find_by_id(item.city_id)
		  city_words = the_city.name.split
      city_abbrev = ""
      for i in 0...3
          if city_words[i] != nil
            city_abbrev = city_abbrev + city_words[i].split(//)[0]
          end
      end
      new_keyword = new_keyword + city_abbrev
    end
       
		new_keyword = new_keyword + "0" unless keyword.nil?
		until keyword.nil?	
			new_keyword.succ!
			#log.debug("Generate Keyword: #{new_keyword}")
			keyword = Keyword.find_by_value(new_keyword)
		end	
		keyword = Keyword.new( :value => new_keyword.upcase )
	end

	def upcase_value
		if !self.value.nil?
			self.value.upcase!
		end
	end

	#define the default successor in the chain of command
	def Keyword.successor=(successor)
		@@successor = successor
    log.debug("#{self.class}.successor = #{successor.class}")
	end
	def Keyword.successor
		return successor
	end
end

