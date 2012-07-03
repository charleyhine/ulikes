class City < ActiveRecord::Base
	belongs_to :state

  def City.find_from_text(text)
    city = nil
    matches = text.match(/^\s*(.*)\s*,\s*([A-Z]{2})$/i)
    if matches.nil?
      matches = text.match(/^\s*(.*)\s+([A-Z]{2})$/i)
    end

    if !matches.nil? && matches.size == 3 #match[0] holds the whole text that matched
      log.debug(matches[2])
      state = State.find_by_abbreviation(matches[2].upcase)
      if !state.nil?
        log.debug("Got state: #{state.name}")
        log.debug("Finding city: #{matches[1].upcase}")
        city = City.find(:first, 
                         :conditions => ["upper(name) = ? and state_id = ?",
                           matches[1].upcase, state])
      end
    end
    return city
  end
end
