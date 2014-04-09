# encoding: utf-8

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
    @output
  end

  def parseOutput(grade_id)

    # Valid compiling no errors
    if @output == ''
      return true
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

    #puts compiler_issue

    # Handle last one
    #compiler_issue.issueList.push(issue)
    
    #if newOne     
      #issuesList.push(compiler_issue)
    #end

    #issuesList
  end
end