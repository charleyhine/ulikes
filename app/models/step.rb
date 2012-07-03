class Step < ActiveRecord::Base
	belongs_to :conversation
	belongs_to :message

	@successor = nil
end
