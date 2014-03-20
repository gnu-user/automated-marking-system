class StaticAnalysis
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

class StaticIssue
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