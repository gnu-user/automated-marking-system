#!/bin/env ruby
# encoding: utf-8

require_relative 'manager'
require_relative 'compiler_issues'

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

    # Nothing useful from this line (since we known colunm offset)
    POINTER_LINE = /\s*\^/

    COMMAND = "g++"
    OPTIONS = "-Wall -o"
    OUTPUT = "2>"
    FILE = "temp.txt"

    def initialize(path="")
        @path_to_file = path
        @executable_name = ""
    end

    def checkFileExist()
        File.exist?(@path_to_file)
    end

    def applyCompiler()
    	process()
    end

    def process()
        super
        
        filename = @path_to_file.scan(FILE_NAME_PARSER)

        @executable_name = filename[0][1]

        @output = Array.new
        %x(#{COMMAND} #{OPTIONS} \"#{@executable_name}\" #{@path_to_file} #{OUTPUT} #{FILE})
            
        File.open(FILE, "r").each_line do |line|
            @output.push(line)
        end

        # Delete the temp file created
        File.delete(FILE)
        @output
    end

    def parseOutput()

        # Valid compiling no errors
        if @output == ""
            return true
        end

        start = 0

        issuesList = Array.new
        @output.each do |line|

            if start == 4
                #4. Try Step 1 again
                if line.match(LINE_PARSER) == nil
                    #5. Try Step 0 again
                    start = 0
                else
                    start = 1
                end
            end

            #So far the parsing should work by:
            if start == 0
                #0. Use FIRST_LINE_PARSER to parse the first method issue
                parsed = line.scan(FIRST_LINE_PARSER)
                if parsed.size > 0
                    filename, where, method_name = parsed[0]
                    puts [filename, where, method_name]
                end
            elsif start == 1

                parsed = line.scan(LINE_PARSER)
                if parsed.size > 0
                    #1. Use LINE_PARSER on the next line
                    filename, line_number, col_number, issue_type, message = parsed[0]
                    puts [filename, line_number, col_number, issue_type, message]
                end
            elsif start == 2

                parsed = line.scan(CODE_LINE_PARSER)

                if parsed.size > 0
                    #2. Use CODE_LINE_PARSER on the next line
                    code = parsed[0]
                    puts code
                end
            elsif start == 3
                #3. Use POINTER_LINE on the next line (or just skip the line)
                parsed = line.match(POINTER_LINE)
            end

            start += 1
        end

        return issuesList
    end
end

compiler = CompilerManager.new("example_programs/example.cpp")

compiler.applyCompiler

issuesList = compiler.parseOutput

issuesList.each do |issue|
	put issue
end