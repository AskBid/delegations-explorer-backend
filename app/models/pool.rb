class Pool < ApplicationRecord
	has_many :active_stakes
	has_many :owners
end
