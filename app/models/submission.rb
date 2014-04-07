class Submission < ActiveRecord::Base
	belongs_to :student
	has_many :grade # 1 per assignment
end
