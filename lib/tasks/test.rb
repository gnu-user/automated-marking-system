class Test
	attr_accessor :name, :description, :ioList, :result

	# Note that ioList is the array of IOElements
	# result is whether the test case passed

	def to_s
        "name = #{@name}, description = #{@description}, ioList = #{@ioList}, result = #{@result}"
    end
end