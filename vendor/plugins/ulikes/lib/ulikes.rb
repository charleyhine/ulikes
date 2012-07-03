# ULikes Main library
require 'logger'

#make the logger print out the way we want it to
class Logger
	def format_message(severity, timestamp, progname, msg)
		timestamp.strftime("%m/%d/%Y %X #{severity} [#{$$}]: #{msg}\n")
	end
end

#make a gobal logger that we can use wherever we go that isn't part of the
#Rails logging, but is inside of Rails
#it's definitely a Hack but very usefull
class LogHelper
	@@log = Logger.new(STDOUT)

	def LogHelper.logger=(logger)
		@@log = logger
	end

	def LogHelper.logger
		return @@log 
	end
end

#define logging methods for all Ruby Objects, makes life easier
def Object.log
  return LogHelper.logger
end

def Object.log_exception(e)
  log.error("#{e.class}: #{e.message}")
  log.error(e.backtrace.join("\n\t"))
end

def Object.log_handle(handler, conversation)
  log.debug("#{handler}.handle() for conversation: #{conversation.id}")
end

#NOTE: expose the Object log methods to the ULikes module
#otherwise they don't get loaded for some reason (probably because of the way
#that the plugins get loaded)
module ULikes
  def log
    return Object.log
  end
  
  def log_exception(e)
    return Object.log_exception(e)
  end

  def log_handle(handler, conversation)
    return Object.log_handle(handler, conversation)
  end
end
