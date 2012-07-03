class ConversationState < ActiveRecord::Base
	has_many :conversations

	module ConversationStateEnum
		OPEN = ConversationState.find_by_name("OPEN")
		CLOSED = ConversationState.find_by_name("CLOSED")
	end
	include ConversationStateEnum
end
