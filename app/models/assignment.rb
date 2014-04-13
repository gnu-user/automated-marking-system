##############################################################################
#
# Automated Marking System (AMS)
# 
# A scalable automated marking system that provides automated marking, quality
# feedback, and cheating detection all in one easy to use solution.
#
#
# Copyright (C) 2014, Joseph Heron, Jonathan Gillett, Daniel Smullen, 
# and Khalil Fazal
# All rights reserved.
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
class Assignment < ActiveRecord::Base
	belongs_to :admin
	belongs_to :submission
	has_many :test_cases
	has_many :inputs, :through => :test_cases
	has_many :clone_incident

	attr_accessor :submission_count, :avg_grade

  #TODO: Doesn't work when trying to enforce that due dates must occur after posted dates
  #https://github.com/adzap/validates_timeliness/#readme
  validates_time :posted, on_or_after: :today
  validates_time :due, on_or_after: :posted
end
