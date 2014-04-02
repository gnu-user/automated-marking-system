class DiffFile < ActiveRecord::Base
	belongs_to :clone_incident
	has_many :diff_entries
	has_many :lines, through: :diff_entries
end
