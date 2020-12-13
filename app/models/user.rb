class User < ApplicationRecord
	# has_many :stakes
	has_secure_password
end
