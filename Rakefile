# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'net/http'
require 'net/https'


task :epochStartProcedure => [:getPools, :getStakes, :getRewards] do
	ARGV.each { |a| task a.to_sym do ; end }
	args = ARGV.slice(1,ARGV.length)

	puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
	puts "::::::::::::::::       POOLS scraping       :::::::::::::::::::::"
	puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
	start0 = Time.now
	Rake::Task[:getPools]
	finish0 = Time.now
	total = ((finish0 - start0)/60).to_i

	args.each do |arg|
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts "::::::::::::::::         Task Shift         :::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts "::::::::::::::::     get_STAKES starting    :::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		start = Time.now
		Rake::Task[:getStakes].invoke(arg)
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts "::::::::::::::::         Task Shift          ::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts "::::::::::::::::     get_REWARDS starting    ::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		Rake::Task[:getRewards].invoke(arg)
		finish = Time.now
		minutes = ((finish - start)/60).to_i
		total += minutes
		puts "time to process: #{minutes} minutes to complete epoch #{arg}"
		puts "TOTAL time since start: #{total} minutes"
		puts ""
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts "::::::::::::::::         EPOCH END           ::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts "::::::::::::::::       epoch #{arg} ended       ::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		puts ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
	end
	puts "TOTAL FINAL time to process: #{total} minutes to complete epochs #{args}"
end



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
				obj = query_graphql("{ stakePools(limit: #{step}, order_by: {id: asc}, offset: #{count}) { id hash pledge margin rewardAddress updatedIn { block { epochNo }} url }}")
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

		obj.each.with_index do |pool_hash, i|
			print "pools processed: #{count + i + 1}"
			print "\r"
			pool = Pool.find_or_initialize_by(poolid: pool_hash['id'])
			puts "\n> ! > ! > #{pool_hash['url']} :NEW POOL!" if !pool.persisted?

			pool.hashid = pool_hash['hash']
			pool.updatedIn = pool_hash['updatedIn']['block']['epochNo']
			pool.url = pool_hash['url']
			if pool.save
				#this is necessary as owner addresses are not always in active_stakes
				owner = Owner.find_or_create_by(address: pool_hash['rewardAddress'])
				owner.pool_id = pool.id
				owner.save
				stake = Stake.find_or_initialize_by(address: pool_hash['rewardAddress'])
				if !stake.persisted?
					puts "!!!#{stake.address} not saved!" if !stake.save
				end				
			else
				puts "!!!not saved! #{pool_hash['id']}"
			end
		end
		count += step
	end
	puts ""
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
	count = 0
	if args[-1].include?('offset:')
		count = args[-1].gsub('offset:', '').to_i
		args = args.slice(0, args.length - 1 )
	end
	args = [last_epoch()] if args.empty?

	args.each do |arg|
		start = Time.now
		puts "::::::::::::::::::::::::::::::::::::::::::"
		epochNo = arg
		
		stakeTotNo = stake_aggregate_count(epochNo)
		step = 2000
		mod = stakeTotNo % step
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
				print "stakes proccessed: #{count + i + 1}"
				print "\r"
				pool = Pool.find_or_create_by(poolid: stake_hash['registeredWith']['id'])			
				activeStake = ActiveStake.new(epochno: stake_hash['epochNo'], amount: stake_hash['amount'], pool_id: pool.id, stake_id: stake.id)
				if !activeStake.save
					puts "!!!there was already an activeStake entry for stake #{stake.address} in epochNo #{stake_hash['epochNo']}"
					puts activeStake.errors.messages
				end
			end
			puts ''
			count += step
		end
		puts "total made: #{processed} / #{stakeTotNo} = #{((processed.to_f / stakeTotNo.to_f)*100).to_i}%"
		finish = Time.now
		puts "time to process: #{((finish - start)/60).to_i} minutes to complete epoch #{arg}"
	end
end



task :getRewards => :environment do #per epochNo (as argument)
	ARGV.each { |a| task a.to_sym do ; end }
	args = ARGV.slice(1,ARGV.length)
	count = 0
	if args[-1].include?('offset:')
		count = args[-1].gsub('offset:', '').to_i
		args = args.slice(0, args.length - 1 )
	end
	args = [last_epoch()] if args.empty?

	args.each do |arg|
		start = Time.now
		puts "::::::::::::::::::::::::::::::::::::::::::"
		epochNo = arg
	
		aggregate_count = rewards_aggregate_count(epochNo)

		if aggregate_count != 0
			step = 2000
			mod = aggregate_count % step
			processed = 0 + count

			until count > (aggregate_count - mod) do

				obj = query_graphql("{rewards(limit: #{step},order_by: {address: {_eq: \"stake\"}},offset: #{count},where: {earnedIn: {blocks: {epoch: {number: {_eq: #{epochNo}}}}}}){ address earnedIn { number } amount stakePool{id}}}")

				obj = obj['rewards']
				if obj.empty?
					puts "no rewards have been given yet for epoch #{epochNo}"
				end

				puts "-------------------------------------------"
				puts "processing #{obj.count} rewards offset from the #{count}th rewards ..."
				puts "total made so far: #{processed} / #{aggregate_count} = #{((processed.to_f / aggregate_count.to_f)*100).to_i}%"

				obj.each.with_index do |reward_hash, i|
					stake = Stake.find_by(address: reward_hash['address'])

					if !stake
						puts "> ! > ! > #{reward_hash['amount']} in epoch #{reward_hash['earnedIn']['number']} haven't found address reward_hash['address'] in local database"
						puts ""
					else
						print "goint to add rewards for the #{count + i + 1}th address, "
					end

					if stake
						activeStake = stake.active_stakes.find_or_create_by(epochno: reward_hash['earnedIn']['number'])
						activeStake.rewards = reward_hash['amount']
						if !activeStake.pool_id
							pool = Pool.find_by(poolid: reward_hash['stakePool']['id'])
							activeStake.pool_id = pool.id
						end
						print "rewards added."
						print "\r"
					else
						puts "stake address found but reward not added for #{reward_hash['address']}"
					end

					if (!stake.save) #before was (!stake) and erlier (!stake || !stake.save)
						puts "!!!stake not saved! are there activeStake for epoch #{epochNo}? or maybe owner_stake was found above?"
						puts "#{stake.errors.message}" if stake
						puts "processed: #{processed} (offset: #{processed} to examine)"
						puts ""
					else
						processed += 1
					end
				end
				puts ''
				count += step
			end
			puts ""
			puts "total made: #{processed} / #{aggregate_count} = #{((processed.to_f / aggregate_count.to_f)*100).to_i}%"
		else
			puts "no rewards have been given yet for epoch #{epochNo}"
		end
		finish = Time.now
		puts "time to process: #{((finish - start)/60).to_i} minutes to complete epoch #{arg}"
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

	attempts = 0

	begin
		puts ''
		puts '$ ...'
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
		  read_timeout: 15
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end
		puts "API response code: #{response.code}"
		puts ""
		JSON.parse(response.body)['data']
	rescue
		attempt += 1
		puts "retrying #query_graphql because it failed #{attempt} times"
		query_graphql(query)
	end
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