class TestCase < ActiveRecord::Base
	belongs_to :assignment
	has_many :inputs
end
