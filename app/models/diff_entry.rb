class DiffEntry < ActiveRecord::Base
	belongs_to :diff_file
	has_many :lines
end
