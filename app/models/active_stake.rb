class ActiveStake < ApplicationRecord
	belongs_to :pool
	belongs_to :stake
end
