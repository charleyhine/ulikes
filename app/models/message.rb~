require 'net/smtp'
require 'tmail'

class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :carrier
	belongs_to :message_state
	has_one :conversation_step
	belongs_to :conversation

	validates_presence_of :to, :from, :data
	
	@@from = "all@lkz.cc"
	@@smtp_server = "mail.lkz.cc"
	@@domain = "applesauce.scrapping.cc"
	@@password = "cheeseballs"

	def Message.parse_sms(pop_message)
		mail = TMail::Mail.parse(pop_message)

		from = mail.from_addrs[0].spec #get the pure addess
		to   = mail.to_addrs[0].spec 

		message = nil
		if from =~ /1?(\d{10})@(.*)/ 
			phone_number = $1
			carrier_domain = $2
			body = Message.get_tmail_body(mail).lstrip.rstrip

			carrier = Carrier.find_by_email_domain(carrier_domain.downcase)
			if !carrier.nil?
				message = Message.new( :to => to,
													 :from => phone_number,
													 :data => body,
													 :carrier => carrier
												 )

			end	
		elsif from =~ /jholla14@gmail.com/
			log.debug("Got a test message!")

			#JHOLLANDER: this is to allow for me to do testing using a plain email
			#client
			phone_number = '6163046107'
			carrier_domain = 'VTEXT.COM'
			body = Message.get_tmail_body(mail).lstrip.rstrip

			carrier = Carrier.find_by_email_domain(carrier_domain.downcase)
			message = Message.new( :to => to,
														 :from => phone_number,
														 :data => body,
														 :carrier => carrier
													 )
		end
		return message
	end

	def Message.send_sms(user, text, conversation = nil)
		smtp = nil
		begin

			#put some branding on this message
			text = "ulikes: " + text + " Visit us at: www.ulikes.org"

			#this is for testing purposes
			if !user.nil? && !user.email.nil? && user.email == 'jholla14@gmail.com'
				log.debug("Sending out test message.")
				return Message.send_email(user, text, conversation)
			end

			if !user.carrier.nil?
				message = Message.create(
																:to => user.sms_email, 
																:from => @@from, 
																:data => text, 
																:carrier => user.carrier, 
																:user => user, 
																:conversation => conversation  
															 )

				smtp = Net::SMTP.start(@@smtp_server, 25, @@domain,
															 @@from, @@password, :plain)
				mail = message.create_tmail()
				smtp.send_message mail.encoded, @@from, user.sms_email
				smtp.finish

				message.message_state = MessageState::SENT
			end
			return message
		ensure
			if !smtp.nil? && smtp.started?
				smtp.finish
			end
		end
	end

	def Message.send_email(user, text, conversation = nil)
		smtp = nil
		begin
			message = Message.create(
															:to => user.email, 
															:from => @@from, 
															:data => text, 
															:user => user, 
															:conversation => conversation  
														 )

			smtp = Net::SMTP.start(@@smtp_server, 25, @@domain,
														 @@from, @@password, :plain)
			mail = message.create_tmail('ulikes')
			smtp.send_message mail.encoded, @@from, user.email
			smtp.finish

			message.message_state = MessageState::SENT
			return message
		rescue
			message.message_state = MessageState::SEND_ERROR
		ensure
			if !smtp.nil? && smtp.started?
				smtp.finish
			end
		end
	end

	def Message.send_error_email(text, e)
		smtp = nil
		begin
			smtp = Net::SMTP.start(@@smtp_server, 25, @@domain,
														 @@from, @@password, :plain)

			text << "\n#{e.class}: #{e.message}\n"
			text << e.backtrace.join("\n\t")
			smtp.send_message text, 'errors@lkz.cc', ['jholla14@gmail.com', 'charles.hine@gmail.com']
		ensure
			if !smtp.nil? && smtp.started?
				smtp.finish
			end
		end
	end

	def create_tmail(subject = '')
		mail = TMail::Mail.new
		mail.to = self.to
		mail.from = self.from
		mail.subject = subject
		mail.date = Time.now
		mail.mime_version = '1.0'
		mail.set_content_type 'text', 'plain'
		mail.body = self.data
		return mail
	end

	def Message.get_tmail_body(mail)
		#handle multipart emails (look for the text version of the body)
		if mail.multipart? 
			mail.parts.each do |m|
				if m.main_type == 'text' && !(m.body =~ /<html>/)
					return m.body
				end
			end
		else
			return mail.body
		end
	end

end
