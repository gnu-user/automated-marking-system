class Grade < ActiveRecord::Base
	belongs_to :submission
	has_one :compiler_issue
	has_one :static_issue
	has_many :tests # Stores the results for the student
end
