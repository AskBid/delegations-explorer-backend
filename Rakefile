# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'net/http'
require 'net/https'



task :getPools => :environment do #per epochNo (as argument)
	aggregate_count = pools_aggregate_count()
	step = 500
	mod = aggregate_count % step
	count = 0
	processed = 0

	until count > (aggregate_count - mod) do
		success = false

		until success do
			begin
				obj = query_graphql("{ stakePools(limit: #{step}, order_by: {id: asc}, offset: #{count}) { id hash pledge margin rewardAddress updatedIn { block { epochNo }} url}}")
				success = true
			rescue
				puts 'there was an error during query_graphql().'
				puts 'query_graphql() will be rexecuted'
			end
		end
		obj = obj['stakePools']

		puts "-------------------------------------------"
		puts "processing #{obj.count} stakePools offset from the #{count}th stakePool ..."
		puts "total made so far: #{processed} / #{aggregate_count} = #{((processed.to_f / aggregate_count.to_f)*100).to_i}%"
		processed += obj.count

		obj.each do |pool_hash|
			pool = Pool.find_or_initialize_by(poolid: pool_hash['id'])

			pool.hashid = pool_hash['hash']
			pool.updatedIn = pool_hash['updatedIn']['block']['epochNo']
			pool.url = pool_hash['url']
			puts '!!!not saved!' if !pool.save
		end
		puts "-------------------------------------------"
		count += step
	end
	puts "total made: #{processed} / #{aggregate_count} = #{((processed.to_f / aggregate_count.to_f)*100).to_i}%"
end



task :getTickers => :environment do
	Pool.all.each do |pool|
		if !pool.ticker
			ticker = read_ticker_from_adapoolsDOTorg(pool.hashid)
			# ticker = read_pool_url_json(pool.url)
			pool.ticker = ticker if ticker
			pool.save
			puts pool.ticker
		else
			puts "`#{pool.ticker}"
		end
	end
end



task :getStakes => :environment do #per epochNo (as argument)
	ARGV.each { |a| task a.to_sym do ; end }
	args = ARGV.slice(1,ARGV.length)
	args = [last_epoch()] if args.empty?

	args.each do |arg|
		start = Time.now
		puts "::::::::::::::::::::::::::::::::::::::::::"
		epochNo = arg
		
		stakeTotNo = stake_aggregate_count(epochNo)
		step = 500
		mod = stakeTotNo % step
		count = 0
		processed = 0 + count

		until count > (stakeTotNo - mod) do
			puts "-------------------------------------------"

			obj = query_graphql("{ activeStake(limit: #{step}, order_by: {address: asc}, offset: #{count}, where: {epochNo: {_eq: #{epochNo}}}) { address amount epochNo registeredWith { id } }}")

			obj = obj['activeStake']

			puts "processing #{obj.count} stakes for epochNo #{epochNo} offset from the #{count}th stake ..."
			puts "total made so far: #{processed} / #{stakeTotNo} = #{((processed.to_f / stakeTotNo.to_f)*100).to_i}%"
			processed += obj.count

			obj.each.with_index do |stake_hash, i|
				stake = Stake.find_or_initialize_by(address: stake_hash['address'])
				print "stake #{stake.address} #{count + i + 1}"
				print "\r"
				pool = Pool.find_or_create_by(poolid: stake_hash['registeredWith']['id'])
				if !stake.persisted?
					puts "!!!#{stake.address} not saved!, already exist?" if !stake.save
				end				
				activeStake = ActiveStake.new(epochno: stake_hash['epochNo'], amount: stake_hash['amount'], pool_id: pool.id, stake_id: stake.id)
				if !activeStake.save
					puts "!!!there was already an entry for stake #{stake.address} in epochNo #{stake_hash['epochNo']}"
					puts activeStake.errors.messages
				end
			end
			puts ''
			count += step
		end
		puts "total made: #{processed} / #{stakeTotNo} = #{((processed.to_f / stakeTotNo.to_f)*100).to_i}%"
		finish = Time.now
		puts "time to process: #{(finish - start)/60} minutes to complete #{arg} epoch"
	end
end



task :getRewards => :environment do #per epochNo (as argument)
	ARGV.each { |a| task a.to_sym do ; end }
	args = ARGV.slice(1,ARGV.length)
	args = [last_epoch()] if args.empty?

	args.each do |arg|
		start = Time.now
		puts "::::::::::::::::::::::::::::::::::::::::::"
		epochNo = arg
	
		aggregate_count = rewards_aggregate_count(epochNo)

		if aggregate_count != 0
			step = 500
			mod = aggregate_count % step
			count = 0
			processed = 0 + count

			until count > (aggregate_count - mod) do

				obj = query_graphql("{rewards(limit: #{step},order_by: {address: {_eq: \"stake\"}},offset: #{count},where: {earnedIn: {blocks: {epoch: {number: {_eq: #{epochNo}}}}}}){ address earnedIn { number } amount }}")

				obj = obj['rewards']
				if obj.empty?
					puts "no rewards have been given yet for epoch #{}"
				end

				puts "-------------------------------------------"
				puts "processing #{obj.count} rewards offset from the #{count}th rewards ..."
				puts "total made so far: #{processed} / #{aggregate_count} = #{((processed.to_f / aggregate_count.to_f)*100).to_i}%"
				processed += obj.count

				obj.each.with_index do |reward_hash, i|
					stake = Stake.find_by(address: reward_hash['address'])
					
					if !stake
						puts "#{reward_hash['address']} was not found."
					else
						print "reward for stake #{stake.address} #{count + i + 1} "
					end

					if stake
						activeStake = stake.active_stakes.find_or_create_by(epochno: reward_hash['earnedIn']['number'])
						activeStake.rewards = reward_hash['amount']
						print "rewards added: #{activeStake.rewards}"
						print "\r"
					end
					if !stake || !stake.save 
						puts "!!!not saved!, are there activeStake for epoch #{epochNo}?"
				end
				puts ''
				count += step
			end
			puts "total made: #{processed} / #{aggregate_count} = #{((processed.to_f / aggregate_count.to_f)*100).to_i}%"
		else
			puts "no rewards have been given yet for epoch #{epochNo}"
		end
		finish = Time.now
		puts "time to process: #{(finish - start)/60} minutes to complete #{arg} epoch"
	end
end



def last_epoch()
	query_graphql("{blocks(limit: 1, order_by:{ forgedAt: desc}) {epochNo}}")['blocks'].first['epochNo']
end



def stake_aggregate_count(epochNo)
	res = query_graphql("{activeStake_aggregate(where: {epochNo: {_eq: #{epochNo}}}) {aggregate {count}}}")
	res = res["activeStake_aggregate"]["aggregate"]["count"].to_i
end



def rewards_aggregate_count(epochNo)
	res = query_graphql("{rewards_aggregate(where: {earnedIn: {blocks: {epoch: {number: {_eq: #{epochNo}}}}}}) {aggregate {count}}}")
	res = res["rewards_aggregate"]["aggregate"]["count"].to_i
end



def pools_aggregate_count()
	res = query_graphql("{stakePools_aggregate { aggregate {count}}}")
	res = res["stakePools_aggregate"]["aggregate"]["count"].to_i
end



def query_graphql(query)
	require 'net/http'
	require 'uri'
	require 'json'

	puts 'querying graphql server (inside #query_graphql)'
	puts "query: #{query}"
	uri = URI.parse("http://#{ENV['IP_CARDANO_GRAPHQL_API_SERVER']}:3100")
	request = Net::HTTP::Post.new(uri)
  # request.read_timeout = 5

	request.content_type = "application/json"
	request["Accept"] = "application/json"
	request["Connection"] = "keep-alive"
	request["Dnt"] = "1"
	request["Origin"] = "http://#{ENV['IP_CARDANO_GRAPHQL_API_SERVER']}:3100"

	obj = {"query": query}

	request.body = JSON.dump(obj)

	req_options = {
	  use_ssl: uri.scheme == "https",
	  read_timeout: 5
	}

	response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
	  http.request(request)
	end
	puts "API response code: #{response.code}"
	puts ""
	JSON.parse(response.body)['data']
end



def read_ticker_from_adapoolsDOTorg(hashid)
	begin
		resp = Net::HTTP.get_response(URI.parse("https://adapools.org/pool/#{hashid}"))
		data = resp.body
		puts "https://adapools.org/pool/#{hashid}"
		res = data.split("data-id=\"#{hashid}\"")[1].split(']')[0].split('[')[1]
		if res.length > 2 && res.length < 6
			return res
		else 
			return hashid.slice(0,6)
		end
	rescue
		return hashid.slice(0,6)
	end
end



def read_pool_url_json(url)
	begin
		resp = Net::HTTP.get_response(URI.parse(url))
		data = resp.body
		begin 
			return JSON.parse(data)
		rescue
			puts "this url:                   #{url}"
			url = "#{data.split('<a href="')[1].split('">')[0]}"
			puts "was modified into this url: #{url}"
			read_pool_url(url)
		end
	rescue
		return false
	end
end