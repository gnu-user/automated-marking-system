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
class Array
  def to_csv
    (map {|e| e.to_csv}.join ',') + "\n"
  end
end

class Hash
  def to_csv
    values.to_csv
  end
end

class String
  def to_csv
    self
  end
end

class Fixnum
  def to_csv
    self.to_s
  end
end

class Float
  def to_csv
    self.to_s
  end
end

module AdminHelper


  ActionController::Renderers.add(:csv) { |obj, options|
    filename = options[:filename] || 'data'
    str = (options[:header] || '') + "\n"
    str += obj.respond_to?(:to_csv) ? obj.to_csv : obj.to_s
    send_data str, type: Mime::CSV, disposition: "attachment; filename=#{filename}.csv"
  }
end