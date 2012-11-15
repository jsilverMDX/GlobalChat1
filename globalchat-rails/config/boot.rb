require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])


# set online on the nexus
require 'net/http'

def ping_nexus
	puts "Pinging NexusNet that I'm Online!!"
	url = "http://globalchatnet.herokuapp.com"
	chatnet_name = "GlobalChatNet"
	port = 80
	uri = URI.parse("http://nexusnet.herokuapp.com/online")
	query = {:url => url, :name => chatnet_name, :port => port}
	uri.query = URI.encode_www_form( query )
	Net::HTTP.get(uri)
end

ping_nexus

def nexus_offline
  puts "Informing NexusNet that I have exited!!!"
  Net::HTTP.get_print("nexusnet.herokuapp.com", "/offline")
end

# set nexus offline
at_exit do
	nexus_offline
end
