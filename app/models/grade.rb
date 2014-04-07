class Grade < ActiveRecord::Base
	belongs_to :submission
	has_many :compiler_issue # 1 per assignment
	has_many :static_issue # 1 per assignment
	#has_many :tests # Stores the results for the student
end
