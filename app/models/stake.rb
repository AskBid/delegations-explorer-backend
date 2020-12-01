class Stake < ApplicationRecord
	has_many :active_stakes
	belongs_to :user
end
