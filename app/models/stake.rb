class Stake < ApplicationRecord
	has_many :active_stakes
	has_many :user_stakes
	has_many :users, through: :user_stakes

	validates_uniqueness_of :address, {message: "%{value} address already exist"}
end
