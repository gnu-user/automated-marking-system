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
      end
    end
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