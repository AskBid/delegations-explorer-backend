class User < ApplicationRecord
	# has_many :stakes
	has_secure_password

	validates :username, presence: { message: "%{attribute} must be given" }, length: {maximum: 10}
  validates :password, length: {maximum: 10}
end
