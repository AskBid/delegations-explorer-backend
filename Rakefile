# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :query => :environment do
	ARGV.each { |a| task a.to_sym do ; end }
	query_string = ARGV[1]
	#rake query "{stakePools(offset: 1000) {id rewardAddress fixedCost margin pledge}}"
	#rake query "{ activeStake { address amount epochNo registeredWith { id } }}"
	#rake query "{blocks(offset: 0) {epochNo}}"
	obj = query_graphql(query_string)
	puts obj['data']['activeStake'][0]
end

task :getPools => :environment do #per epochNo (as argument)

	"{stakePools { id hash pledge margin rewardAddress updatedIn url { block { epochNo }}}}"
	binding.pry
	stakeTotNo = pools_aggregate_count()
	step = 500
	mod = stakeTotNo % step
	count = 0
	processed = 0

	# until count > (stakeTotNo - mod) do
	# 	exist = 0
	# 	created = 0
	# 	success = false

	# 	until success do
	# 		begin
	# 			obj = query_graphql("{ activeStake(limit: #{step}, order_by: {address: asc}, offset: #{count}, where: {epochNo: {_eq: #{epochNo}}}) { address amount epochNo registeredWith { id } }}")
	# 			success = true
	# 		rescue
	# 			puts 'there was an error during query_graphql().'
	# 			puts 'query_graphql() will be'
	# 		end
	# 	end
	# 	obj = obj['activeStake']

	# 	puts "-------------------------------------------"
	# 	puts "processing #{obj.count} stakes for epochNo #{epochNo} offset from the #{count}th stake ..."
	# 	puts "total made so far: #{processed} / #{stakeTotNo} = #{((processed.to_f / stakeTotNo.to_f)*100).to_i}%"
	# 	processed += obj.count

	# 	obj.each do |stake_hash|
	# 		stake = ActiveStake.find_or_initialize_by(address: stake_hash['address'], epochno: stake_hash['epochNo'])
	# 		if stake.persisted?
	# 			exist += 1
	# 		else
	# 			created += 1
	# 		end
	# 		stake.amount = stake_hash['amount']
	# 		puts '!!!not saved!' if !stake.save
	# 	end
	# 	puts "#{exist} activeStakes were updated"
	# 	puts "#{created} activeStakes were created New"
	# 	puts "-------------------------------------------"
	# 	count += step
	# end
end

task :getActiveStakes => :environment do #per epochNo (as argument)
	ARGV.each { |a| task a.to_sym do ; end }
	epochNo = ARGV[1].to_i
	epochNo = last_epoch() if epochNo == 0
	
	stakeTotNo = stake_aggregate(epochNo)
	step = 500
	mod = stakeTotNo % step
	count = 0
	processed = 0

	until count > (stakeTotNo - mod) do
		exist = 0
		created = 0
		success = false

		until success do
			begin
				obj = query_graphql("{ activeStake(limit: #{step}, order_by: {address: asc}, offset: #{count}, where: {epochNo: {_eq: #{epochNo}}}) { address amount epochNo registeredWith { id } }}")
				success = true
			rescue
				puts 'there was an error during query_graphql().'
				puts 'query_graphql() will be'
			end
		end
		obj = obj['activeStake']

		puts "-------------------------------------------"
		puts "processing #{obj.count} stakes for epochNo #{epochNo} offset from the #{count}th stake ..."
		puts "total made so far: #{processed} / #{stakeTotNo} = #{((processed.to_f / stakeTotNo.to_f)*100).to_i}%"
		processed += obj.count

		obj.each do |stake_hash|
			stake = ActiveStake.find_or_initialize_by(address: stake_hash['address'], epochno: stake_hash['epochNo'])
			if stake.persisted?
				exist += 1
			else
				created += 1
			end
			stake.amount = stake_hash['amount']
			puts '!!!not saved!' if !stake.save
		end
		puts "#{exist} activeStakes were updated"
		puts "#{created} activeStakes were created New"
		puts "-------------------------------------------"
		count += step
	end
end

def last_epoch()
	# query_graphql("{blocks(limit: 1, offset: 3, order_by:{ forgedAt: desc}) {epochNo}}")
	query_graphql("{blocks(limit: 1, order_by:{ forgedAt: desc}) {epochNo}}")['blocks'].first['epochNo']
end

def stake_aggregate(epochNo)
	res = query_graphql("{activeStake_aggregate(where: {epochNo: {_eq: #{epochNo}}}) {aggregate {count}}}")
	res = res["activeStake_aggregate"]["aggregate"]["count"].to_i
end

def pools_aggregate_count()
	res = query_graphql("{stakePools_aggregate { aggregate {count}}}")
	res = res["stakePools_aggregate"]["aggregate"]["count"].to_i
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