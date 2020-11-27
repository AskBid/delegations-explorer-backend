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

task :query_stakes => :environment do
	ARGV.each { |a| task a.to_sym do ; end }
	epochNo = ARGV[1].to_i
	epochNo = last_epoch() if epochNo == 0

	obj = query_graphql("{ activeStake(where: {epochNo: {_eq: #{epochNo}}}) { address amount epochNo registeredWith { id } }}")
	obj = obj['activeStake']
	obj.each do |stake_hash|
		stake = ActiveStake.find_or_create_by(
			address: stake_hash['address']
		)
		stake.amount = stake_hash['amount']
		stake.epochno = stake_hash['epochNo']
	end
end

def last_epoch()
	# query_graphql("{blocks(limit: 1, offset: 3, order_by:{ forgedAt: desc}) {epochNo}}")
	query_graphql("{blocks(limit: 1, order_by:{ forgedAt: desc}) {epochNo}}")['blocks'].first['epochNo']
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

	obj = {"query": query}

	request.body = JSON.dump(obj)

	req_options = {
	  use_ssl: uri.scheme == "https",
	}

	response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
	  http.request(request)
	end
	# puts response.code
	JSON.parse(response.body)['data']	
end