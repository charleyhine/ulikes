#!/usr/local/bin/ruby
# = Email Processor
# Processes emails as SMS messages from an SMS to e-mail gateway, such as
# vtext.com or cingularme.com
#
# == Usage
#
#   ruby email_processor.rb -d DB_ENV 
#
#   -d = run as a daemon
#   DB_ENV = development, test, or production
#
require '../config/environment' # sets up the rails load path
require 'yaml' 									# for getting db config
require 'active_record' 				# for db stuff
require 'ulikes'

#import the ULikes modules
include ULikes
include ULikes::Messaging

# The class that handles all the work
class EmailProcessor
  # Set up default args and load the database YAML file
	def initialize()
		@db_env = 'development'
		@daemonize = false
		@config = YAML::load(File.open('../config/database.yml')) 
		@pop = nil
		@msg_proc = nil
	end

  # Parse the command line arguments
	def parse_args()
		for arg in ARGV
			if arg == "-d"
				@daemonize = true
			elsif arg == "development" || arg == "production"
				@db_env = arg
			end
		end
		puts "Using DB: #{@db_env}"
	end

  # Display a use
	def usage()
			puts 'usage: email_processor.rb [-d] [developement|production]'
			exit
	end
	private :usage

  # Basically is the main() method, 
  # handles forking if running as a daemon
	def exec()
		#set up the ULikes LogHelper
		if @daemonize
			LogHelper.logger = Logger.new('../log/email_processor.log', 'daily')
		else
			LogHelper.logger = Logger.new(STDOUT)
		end
		@pop = PopHelper.new
		@msg_proc = MessageProcessor.new

		if @db_env == 'development'
			ActiveRecord::Base.logger = LogHelper.logger
		end

		log.info("Starting up!")
		if @daemonize 
			# spawn a new daemon process
			pid = fork do
				run()
			end
			Process.detach(pid)
		else
			#just run the script and retain the console
			run()
		end
	end

  # This is the method where we do the processing
	def run()
		while 0
			begin 
				log.info 'Connecting to email server...'
				if @pop.connect() 
					#make the db connection
          log.info "Processing #{@pop.message_count} messages..."

					ActiveRecord::Base.establish_connection(@config[@db_env])
          @pop.each_mail do |m| 
            proc_msg(m)							
          end
					ActiveRecord::Base.connection.disconnect!

					@pop.disconnect()
					log.info "Processing complete."
					log.info("")
				else
					log.error "Could not connect to mail server!\n"
					log.info("")
				end
			rescue Exception => e
				log_exception(e)
				Message.send_error_email("Error processing an SMS message.", e)
				@pop.disconnect()
				sleep(30)
			end
			sleep(15)
		end	
		log.close
	end
	private :run

	# Process an message which was retrieved from the POP3 server.
  #
  # * This method could be multi-threaded
  # * NOTE: For a multi-threaded method set ActiveRecord::Base.allow_concurrency = true
  #
	def proc_msg(m)
    message = nil
		begin
      #TODO: spawn new thread here when through put needs to be higher
			Message.transaction do
				message = @pop.process_email(m)

				@msg_proc.process(message) unless message.nil?
				@pop.delete(m)
			end
		rescue Exception => e
			if !message.nil? && !message.id.nil?
				log.error("Exception processing message: #{message.id}")
			end
			log.error("#{e.class}: #{e.message}")
			log.error(e.backtrace.join("\n\t"))
		end
	end
	private :proc_msg

end

#the main "method"
puts "EmailProcessor Script v1.0"
email_proc = EmailProcessor.new
email_proc.parse_args()
email_proc.exec()
