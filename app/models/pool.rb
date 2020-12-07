class Pool < ApplicationRecord
	has_many :active_stakes
	has_many :pool_reward_addresses
	has_many :pool_owners
end
