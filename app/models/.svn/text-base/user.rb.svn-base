class User < ActiveRecord::Base
	has_one  :preferences, :class_name => "UserPreference"
	has_many :conversations, :order => "created_on"
	has_many :votes, :order => "created_on"
	has_many :messages, :order => "created_on"
	belongs_to :city
	belongs_to :zip_code
	belongs_to :carrier

	validates_length_of :password, :within => 5..16
	validates_presence_of :phone_number
	validates_uniqueness_of :email, :phone_number, 
		:message => " is already being used!"
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
		:message => " is not in the correct format (eg: user@domain.com)" 
	validates_format_of :phone_number, :with => /^(\d{3})(\d{3})(\d{4})$/i, 
		:message => " is not in the correct format (eg: 6163045555)" 

	def self.authenticate(phone_number, password)
		user = find( :first, 
								 :conditions => ["phone_number = ? AND password = ?", 
								 									phone_number, password ])
		return nil if user.nil?
		return user.id
		nil
	end

	#generate a random passoword
	def self.generate_password
		chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
		(1..8).collect{|a| chars[rand(chars.size)] }.join
	end

	def sms_email
	  self.phone_number + '@' + self.carrier.email_domain
	end
end
