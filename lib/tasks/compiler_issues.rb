require_relative 'issues'

class CompilerIssues
    attr_accessor :filename, :issueList

    def to_s
        "filename = #{@filename}, issues = #{@issueList}"
    end
end