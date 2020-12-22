class Pool < ApplicationRecord
	has_many :active_stakes
	has_many :pool_reward_addresses
	has_many :pool_owners
	has_many :follows
	has_many :users, through: :follow

	def self.clean_all_tickers
		self.all.each do |pool|
			pool.ticker = nil
			pool.save
		end
		return true
	end
end
