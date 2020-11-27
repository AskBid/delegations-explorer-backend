# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :query => :environment do
	#rake query "{ activeStake { address amount epochNo registeredWith { id } }}"
	ARGV.each { |a| task a.to_sym do ; end }
	query_string = ARGV[1]

	obj = query_graphql(query_string)
	puts obj['data']['activeStake'][0]
end

def query_graphql(query) 
	require 'net/http'
	require 'uri'
	require 'json'

	uri = URI.parse("http://#{ENV['IP_CARDANO_GRAPHQL_API_SERVER']}:3100/")
	request = Net::HTTP::Post.new(uri)
	request.content_type = "application/json"
	request["Accept"] = "application/json"
	request["Connection"] = "keep-alive"
	request["Dnt"] = "1"
	request["Origin"] = "http://#{ENV['IP_CARDANO_GRAPHQL_API_SERVER']}:3100"


	activeStake = {"query": query}

	request.body = JSON.dump(activeStake)

	req_options = {
	  use_ssl: uri.scheme == "https",
	}

	response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
	  http.request(request)
	end
	# puts response.code
	JSON.parse(response.body)		
end