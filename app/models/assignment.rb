class Assignment < ActiveRecord::Base
	belongs_to :admin
	belongs_to :submission
	#has_many :tests #both sample and actual
	has_many :clone_incident
end
