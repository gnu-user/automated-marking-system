class Issues
    attr_accessor :method_name, :line_number, :col_number, :issue_type, :message, :relavent_code

    def to_s
        "method_name = #{@method_name}, line_number = #{@line_number}, col_number = #{@col_number}, issue_type = #{@issue_type}, message = #{@message}, relavent_code = #{@relavent_code}"
    end
end