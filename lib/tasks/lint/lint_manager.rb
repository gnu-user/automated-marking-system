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
require_relative '../manager'
#require_relative 'static_issues'

class LintManager < Manager

  # Format [relative_path/filename:lineNumber]:  (issue_flag) description...
  LINE_PARSER = /\[(.+):([0-9]+)\]: \((.+)\) (.*)/

  COMMAND = 'cppcheck'
  OPTIONS = '--enable=all --force'
  OUTPUT = '2>'
  FILE = 'temp.txt'

  def applyLint
    process
  end

  def process
    super
    @output = Array.new
    %x(#{COMMAND} #{OPTIONS} #{@path_to_file} #{OUTPUT} #{FILE})

    File.open(FILE, 'r').each_line do |line|
      @output.push(line)
    end

    # Delete the temp file created
    File.delete(FILE)
    @output
  end

  def parseOutput(grade_id)

    result = Array.new

    # Delete all pre-existing test date
    sa = StaticAnalysis.where("grade_id = #{grade_id}")
    
    sa.each do |i|
      StaticIssue.where("static_analysis_id = #{i.id}").delete_all
    end
    sa.delete_all

    #issuesList = Array.new
    index = 0
    filenameList = Hash.new
    sa = nil

    @output.each do |line|
      parsed = line.scan(LINE_PARSER)

      # There should only be 1 value
      if parsed.size == 1
        filename, line, type, description = parsed[0]

        value = filenameList[filename]
        if value == nil
          filenameList[filename] = index
          sa = StaticAnalysis.new
          sa.filename = filename
          sa.grade_id = grade_id
          sa.save
          index +=1
        end
        si = StaticIssue.new
        si.line_number = line
        si.type = type
        si.description = description
        si.static_analysis_id = sa.id
        si.save

        result.push(type)
      end
    end
    
    return result
  end
end

=begin
manager = LintManager.new('~/source_code/capstone/src/')

manager.applyLint

issuesList = manager.parseOutput

if issuesList.size > 0
  puts issuesList
else
  puts 'No issues found'
end
=end