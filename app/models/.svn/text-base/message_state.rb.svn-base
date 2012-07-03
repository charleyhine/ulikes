class MessageState < ActiveRecord::Base
	has_many :messages

	#faux enumerations 
	module MessageStateEnum
		UNSET = nil
		RECEIVED = MessageState.find_by_name("Received")
		SENT = MessageState.find_by_name("Sent")
		#UNPROCESSED = MessageState.find_by_name("Unprocessed")
		#PROCESSING = MessageState.find_by_name("Processing")
		SEND_ERROR = MessageState.find_by_name("SendError")
	end
	include MessageStateEnum
end
