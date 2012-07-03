#!/usr/local/bin/ruby

require 'rubygems'
require 'active_support/inflector'

IO.foreach("db/schema.rb") { |line| 
	if line =~ /create_table :(.*),/
		table = Regexp.last_match(1)
		names = table.split(/_/)
		model_name = ""
		for name in names 
			model_name += Inflector.singularize(name.capitalize)
		end	
		puts "Model: " + model_name
		system("script/generate", "model", model_name)
		puts $?
	end
}
