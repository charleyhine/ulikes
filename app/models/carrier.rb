class Carrier < ActiveRecord::Base
	#these are slow loading and we don't need them
	#lets just leave them out for now
	#has_many :messages  
	#has_many :users
	
	validates_presence_of :email_domain
end
