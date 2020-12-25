class ActiveStake < ApplicationRecord
	belongs_to :pool
	belongs_to :stake

	validates_uniqueness_of :stake_id, scope: [:epochno], message: "%{value} already has this epochNo"

	scope :by_epochno, -> (epochno) {where('epochno = ?', epochno)}
	scope :by_pool, -> (pool_id) {where('pool_id = ?', pool_id)}
end
