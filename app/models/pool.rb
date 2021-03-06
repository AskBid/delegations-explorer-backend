class Pool < ApplicationRecord
	has_many :active_stakes
	has_many :pool_reward_addresses
	has_many :pool_owners
	has_many :follows
	has_many :users, through: :follow

	@@current_epoch

	def self.current_epoch=(epochno)
		@@current_epoch = epochno
	end

	def reward_ratio()
		as = self.active_stakes.by_epochno(@@current_epoch)
		values = as.map do |as|
			if as.rewards.to_i > 0 && as.rewards
				as.amount.to_i / as.rewards.to_i
			end
		end
		avg = modes(values)
		avg[0] if avg
	end

	def self.empty_all_tickers
		self.all.each do |pool|
			pool.ticker = nil
			pool.save
		end
		return true
	end

	def modes(array, find_all=true)
	  histogram = array.inject(Hash.new(0)) { |h, n| h[n] += 1; h }
	  modes = nil
	  histogram.each_pair do |item, times|
	    modes << item if modes && times == modes[0] and find_all
	    modes = [times, item] if (!modes && times>1) or (modes && times>modes[0])
	  end
	  return modes ? modes[1...modes.size] : modes
	end
end
