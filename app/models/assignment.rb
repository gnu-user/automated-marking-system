class Assignment < ActiveRecord::Base
	belongs_to :admin
	belongs_to :submission
	has_many :test_cases
	has_many :inputs, :through => :test_cases
	has_many :clone_incident
end
