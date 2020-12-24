class User < ApplicationRecord
	has_many :user_stakes
	has_many :stakes, through: :user_stakes
	has_many :follows
	has_many :active_stakes, through: :stakes
	has_many :pools, through: :active_stakes
	has_many :followed_pools, through: :follows, source: :pool
	
	has_secure_password

	validates :username, presence: { message: "%{attribute} must be given" }, length: {maximum: 10}
  validates :password, length: {maximum: 10}
end
