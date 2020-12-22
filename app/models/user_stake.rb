class UserStake < ApplicationRecord
	belongs_to :user
	belongs_to :stake

	validates_uniqueness_of :user_id, scope: :stake_id
end
