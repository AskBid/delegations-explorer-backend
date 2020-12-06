class ActiveStake < ApplicationRecord
	belongs_to :pool
	belongs_to :stake

	validates_uniqueness_of :epochno, scope: [:stake_id], message: "%{value} already has this epochNo"
end
