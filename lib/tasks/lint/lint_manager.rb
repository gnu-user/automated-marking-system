require_relative '../manager'
require_relative 'static_issues'

class LintManager < Manager

  # Format [relative_path/filename]: (issue_flag) description...
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

  def parseOutput

    issuesList = Array.new
    @output.each do |line|
      parsed = line.scan(LINE_PARSER)

      # There should only be 1 value
      if parsed.size == 1
        filename, line, type, description = parsed[0]
        issuesList.push(StaticIssues.new(filename, line, type, description))
      end
    end

    issuesList
  end
end

manager = LintManager.new('../example_programs/example.cpp')

manager.applyLint

issuesList = manager.parseOutput

if issuesList.size > 0
  puts issuesList
else
  puts 'No issues found'
end