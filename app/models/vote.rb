class Vote < ActiveRecord::Base
	include ULikes
	belongs_to :user
	belongs_to :item

  after_save :update_vote_count
  after_destroy :update_vote_count

	def Vote.handle(conversation)
    vote_item = nil
    msg_text = conversation.current_message.data
    if msg_text.include?("@")
      log.debug("Got a vote by item name msg: #{msg_text}")
      vote = nil
      vote_item = Item.extract_item_from_text(msg_text)

      if vote_item.nil?
        log.debug("No item found in: #{msg_text}")
				msg_out = "We couldn't find what you were trying to vote for. Please try again."
			  Message.send_sms(conversation.user, msg, conversation)
        conversation.state = ConversationState::OPEN
      else
        log.debug("Found an item: #{vote_item.name_with_location}")
        vote = Vote.cast_and_respond(vote_item, conversation)
        conversation.state = ConversationState::CLOSED
      end

      step = ItemStep.new( :vote => vote,
													 :message => conversation.current_message )
			conversation.steps << step
			conversation.save
    else
      if !Vote.successor.nil?
        Vote.successor.handle(conversation)
      end 
    end
  end

  def Vote.cast_and_respond(item, conversation)
    vote = nil
		item_text = item.name_with_location
    if !Vote.exists(item, conversation.user)
      vote = Vote.create( :user => conversation.user, :item => item )

      log.debug("Vote cast for: #{item.id})")

      vote_count = Vote.count(:conditions => ['item_id = ?', item.id])
      Message.send_sms( conversation.user, 
        "Your vote has been cast for #{item_text}. It has #{item.vote_count} votes.", 
        conversation )
    else
      log.debug("User already voted for: #{item.id}")
      Message.send_sms(conversation.user, 
        "You have already cast a vote for #{item_text}. It has #{item.vote_count} votes.", conversation) 
    end
    return vote
  end

  def update_vote_count
    #sync up the vote_count on item with the number of actual votes
    if !self.item.nil?
      self.item.vote_count = Vote.count(:conditions => ['item_id = ?', self.item.id])
      self.item.save
    end
  end
  private :update_vote_count

	def Vote.exists(item, user)
		vote = Vote.find(:first, 
										 :conditions => ["item_id = ? AND user_id = ?", item.id, user.id])
		if vote.nil?
			return false 
		end
		return true 
	end
end
