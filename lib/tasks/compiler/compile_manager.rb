# encoding: utf-8
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
#require_relative 'compiler_issues'
#require_relative 'issues'

class CompilerManager < Manager
  attr_accessor :executable_name

  # [0] => path to the file, [1] => filename, [2] => extension, [3] => part of extension (not useful)
  FILE_NAME_PARSER = /^(.*\/)?(.+)\.(c([cp]p)?)$/

  # [0] => Filename, [1] => In function, [2] => method signature
  FIRST_LINE_PARSER = /(.*?\..*?): (.*) ‘(.*)’:/

  # [0] => Filename, [1] => line number, [2] => col number, [3] =>type of issue, [4] => message
  LINE_PARSER = /(.*?\..*?):([0-9]*):([0-9])*: (.*): (.*)/

  # [0] => line of code with the issue
  CODE_LINE_PARSER = /\s*(.+)/

  # Nothing useful from this line (since we known column offset)
  POINTER_LINE = /\s*\^/

  COMMAND = 'g++'
  OPTIONS = '-Wall -o'
  OUTPUT = '2>'
  FILE = 'temp.txt'

  def initialize(path='')
    super(path)
    @executable_name = ''
  end

  def applyCompiler
    process
  end

  def process
    super

    filename = @path_to_file.scan(FILE_NAME_PARSER)

    @executable_name = "#{@path_to_file}.o"

    @output = Array.new
    %x(#{COMMAND} #{OPTIONS} \"#{@executable_name}\" #{@path_to_file} #{OUTPUT} #{FILE})

    File.open(FILE, 'r').each_line do |line|
      @output.push(line)
    end

    # Delete the temp file created
    File.delete(FILE)
    return File.exists?(@executable_name)
  end

  def parseOutput(grade_id)

    # Delete all pre-existing test date
    ci = CompilerIssue.where("grade_id = #{grade_id}")
    
    ci.each do |i|
      Issue.where("compiler_issue_id = #{i.id}").delete_all
    end
    ci.delete_all
    

    # Valid compiling no errors
    if @output.empty?
      return nil
    end

    start = 0
    newOne = false

    issuesList = Array.new

    compiler_issue = nil #CompilerIssues.new
    issue = nil #Issues.new

    @output.each do |line|

      if start == 4
        newOne = false
        #4. Try Step 1 again
        #compiler_issue.issueList.push(issue)

        if line.match(LINE_PARSER) == nil

          #issuesList.push(compiler_issue)
          #5. Try Step 0 again
          start = 0
        else
          start = 1
        end
      end

      #So far the parsing should work by:
      case start
        when 0
          #0. Use FIRST_LINE_PARSER to parse the first method issue
          parsed = line.scan(FIRST_LINE_PARSER)
          if parsed.size > 0
            newOne = true
            filename, where, method_name = parsed[0]
            if compiler_issue == nil
              compiler_issue = CompilerIssue.new
              compiler_issue.filename = filename
              compiler_issue.grade_id = grade_id
              compiler_issue.save
            end
            issue = Issue.new
            issue.method = method_name
            issue.compiler_issue_id = compiler_issue.id
            #puts [filename, where, method_name]
          end
        when 1
          parsed = line.scan(LINE_PARSER)
          if parsed.size > 0
            #1. Use LINE_PARSER on the next line
            filename, line_number, col_number, issue_type, message = parsed[0]
            method_name = issue.method
            issue = Issue.new()
            issue.method = method_name
            issue.line_number = line_number
            issue.col_number = col_number
            issue.issue_type = issue_type
            issue.message = message
            issue.compiler_issue_id = compiler_issue.id

            issuesList.push(issue_type)
            #puts [filename, line_number, col_number, issue_type, message]
          end
        when 2
          parsed = line.scan(CODE_LINE_PARSER)
          if parsed.size > 0
            #2. Use CODE_LINE_PARSER on the next line
            code = parsed[0][0]
            issue.relavent_code = code
            issue.save
            #puts code
          end
        when 3
          #3. Use POINTER_LINE on the next line (or just skip the line)
          parsed = line.match(POINTER_LINE)
      end

      #a = gets
      start += 1
    end

    return issuesList
  end
end