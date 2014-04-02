class CloneIncident < ActiveRecord::Base
	has_many :diff_files
	has_many :diff_entries, through: :diff_files
	has_many :lines, through: :diff_entries
end
