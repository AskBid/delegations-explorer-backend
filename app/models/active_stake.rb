class ActiveStake < ApplicationRecord
	belongs_to :pool
	belongs_to :stake

	validates_uniqueness_of :stake_id, scope: [:epochno], message: "%{value} already has this epochNo"
end
