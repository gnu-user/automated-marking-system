class TestCase < ActiveRecord::Base
	belongs_to :assignment
	has_many :inputs

	attr_accessor :testcase

	after_save :parseYaml

	def parseYaml
		if testcase.present?
			#Parse the YAMl
			testcase.split(/(\n\r)|\r|\n/).each do |line|
				test = parseIO(line)
				if test
					#test_cases.push(test)
					test.test_case_id = id
					test.save
				end
			end
		end
	end

	def parseUpload

	end

private 
	def parseIO(line)
		result = line.scan(/(.*): (.*)/)
		if result.size > 0 && result[0].size == 2
			value = Input.new
			if result[0][0] == "input"
				value.input = true
			elsif result[0][0] == "output"
				value.input = false
			else 
				return nil
			end
			value.value = result[0][1]
			return value
		end
		nil
	end
end
