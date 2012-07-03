# ULikes Messaging library - Supplies SMS, email, etc

require 'net/pop'
require 'tmail'
require 'ulikes'
require 'active_record' 				

module ULikes

	module Messaging

		class MessageProcessor
			def initialize
				#set up the chain of command
					
				#TODO: this should be done using a Factory with a Hashtable	
				log.debug("")	
				log.debug("Setting up chain of command...")
        add_to_chain(Conversation, Vote) 
        add_to_chain(Vote, Keyword)
        add_to_chain(Keyword, Help)
        add_to_chain(Help, Error)
				log.debug("")	

				#Keyword.successor = Command
				#Command.successor = Address
				#Address.successor = Error
			end

      def add_to_chain(handler, successor)
        #make sure that the handler can have a successor
        if !handler.respond_to?(:successor)
          class << handler; attr_accessor :successor; end
        end

        #make sure that the successor actually has a handle() function
        if successor.respond_to?(:handle)
          log.debug("#{handler.to_s}.successor = #{successor.to_s}")
          handler.successor = successor 
        else
          raise "Successor must respond to handle() or the chain will break!"
        end
      end
      private :add_to_chain

			def process(message)
				#transaction has been rolled back
				begin
          Conversation.transaction do
            log.info("")
            log.info("Processing message #{message.id} from: #{message.user.phone_number}")
            conversation = Conversation.load(message)
            Conversation.handle(conversation)
          end
				rescue Exception => e
					log_exception(e)
					log.error("An exception occured while handling message: #{message.id}")
					Message.send_sms(message.user, 
						"We had trouble processing your request please try again soon!", nil) 
				end
				log.info("")
			end

		end

		#class for handling messages that fall through the chain of command
		#TODO: base the outgoing message on the conversations expected step
		class Error
			@@successor = nil

			def Error.handle(conversation)
				log_handle(Error, conversation)
				msg = "We could not understand your message. Please try again later."
				Message.send_sms(conversation.user, msg, conversation)

				step = ErrorStep.new( :message => conversation.current_message )
				conversation.steps << step
				conversation.save
				if !Error.successor.nil?
					Error.successor.handle(conversation)
				end 
			end

		end

		#TODO: base the out going message on the conversations expected step
		class Help
			@@successor = nil

			def Help.handle(conversation)
				if conversation.current_message.data =~ /help/i
					log_handle(Help, conversation)
					msg = "Vote for your favorite 'thing'. Text in a keyword to vote."
					Message.send_sms(conversation.user, msg, conversation)

					step = HelpStep.new( :message => conversation.current_message )
					conversation.steps << step
					conversation.save
				elsif !@@successor.nil?
					@@successor.handle(conversation)
				end 
			end

			#define the default successor in the chain of command
			def self.successor=(successor)
				@@successor = successor
        log.debug("Help.successor = #{successor.to_s}")
			end
			def self.successor
				return successor
			end
		end

		#class for getting SMS messages using a POP3 email account
		class PopHelper
			def initialize
				@server_name = "mail.lkz.cc"
				@account = "all@lkz.cc"
				@password = "cheeseballs"
			end

			def connect
				begin
					if @pop.nil? 
						@pop = Net::POP3.new(@server_name)
					end

					if @pop.start(@account, @password)
						return true
					end
				rescue Exception => e
					log_exception(e)
					@pop = nil
				end
				return false
			end

			def disconnect
				if !@pop.nil? && @pop.started?
					@pop.finish
				end
				@pop = nil
			end

			def message_count
				if !@pop.nil? && @pop.started?
					@pop.mails.size
				end
			end

			def delete(mail)
				mail.delete
			end

			def empty?
				return @pop.mails.empty?
			end

			#wrapper for mails each
			def each_mail( &block )  # :yield: message
				@pop.each_mail(&block)
			end

			# analyze a pop email message	
			# 
			# @param pop	a pop e-mail message
			# 
			def process_email(mail)
				message = Message.parse_sms(mail.pop)
				if !message.nil?
					log.info "Got message: '#{message.data}' from: #{message.from}."
					save_message(message)
				else
					log.info 'Message was not an sms message. Ignoring!'
					mail.delete #delete non-sms messages
				end
				return message
			end

			def save_message(message)	
        user = User.find_by_phone_number(message.from)
        if user.nil?
          log.debug("New user: #{message.from}")
          email = message.from
          if message.from == '6163046107'
            email = 'jholla14@gmail.com'
          end
          user = User.new( 
                            :phone_number => message.from,
                            :password => User.generate_password,
                            :email => email
                         )
        end
        user.carrier = message.carrier
        user.save

        message.user = user
        message.save
			end
			private :save_message  #make this a private function

		end #end class PopHelper

	end #end module Messaging
end #end module ULikes


