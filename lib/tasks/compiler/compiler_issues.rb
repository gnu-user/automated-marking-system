require_relative 'issues'

class CompilerIssues
    attr_accessor :filename, :issueList

    def initialize
    	@filename = ""
    	@issueList = Array.new
    end

    def to_s
        "filename = #{@filename}, issues = #{@issueList}"
    end
end