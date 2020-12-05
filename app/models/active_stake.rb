class ActiveStake < ApplicationRecord
	belongs_to :pool
	belongs_to :stake

	validates_uniqueness_of :epochno, scope: [:stake_id]
end
