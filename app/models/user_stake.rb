class UserStake < ApplicationRecord
	belongs_to :user
	belongs_to :stake
end
