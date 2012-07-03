#extra_path = File.join(directory, 'lib', 'ulikes')
#$LOAD_PATH << extra_path
#Dependencies.load_paths << extra_path

Dependencies.load_once_paths.delete(%W( #{RAILS_ROOT}/vendor/plugins/ulikes/lib ))

require 'ulikes'
require 'lookup'
require 'messaging'
require 'pdf'

ActionController::Base.send(:include, ULikes)
ActionController::Base.send(:include, ULikes::Lookup)
ActionController::Base.send(:include, ULikes::Messaging)

ActiveRecord::Base.send(:include, ULikes)
ActiveRecord::Base.send(:include, ULikes::Lookup)
ActiveRecord::Base.send(:include, ULikes::Messaging)
