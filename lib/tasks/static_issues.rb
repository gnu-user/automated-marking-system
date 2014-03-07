class StaticIssues
    attr_accessor :filename, :line, :type, :description

    def initialize(filename, line, type, description)
        @filename = filename
        @line = line
        @type = type
        @description = description
    end

    def to_s
        "filename = #{@filename}, line = #{@line}, type = #{@type}, description #{@description}"
    end
end