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
class StaticAnalysisStructure
    attr_accessor :filename, :issue_list

    def initialize(filename, issue)
        @filename = filename
        @issue_list = Array.new
        @issue_list.push(issue)
    end

    def to_s
        "filename = #{@filename}, issue_list = #{@issue_list}"
    end
end

class StaticIssueStructure
    attr_accessor :line, :type, :description

    def initialize(line, type, description)
        @line = line
        @type = type
        @description = description
    end

    def to_s
        "line = #{@line}, type = #{@type}, description #{@description}"
    end
end