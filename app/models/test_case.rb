class TestCase < ActiveRecord::Base
	belongs_to :assignment
	has_many :inputs

	attr_accessor :testcase

	#before_save :parseYaml

	def self.parseYaml(test_cases, assignment_id)
		state = 0
		test_case = TestCase.new
		#Parse the YAMl
		testcase.split(/(\n\r)|\r|\n/).each do |line|
			# 1. Test name
			# 2. Test description
			# 3. Test ParseIO


			result = line.scan(/(.*): (.*)/)
			if result.size > 0 && result[0].size == 2

				if state == 0
					temp_name = parseName(result)

					if temp_name
						test_case.assignment_id = assignment_id
						test_case.name = temp_name
						# valid name found
						state+=1
					end
				elsif state == 1
					temp_desc = parseDescription(result)

					if temp_desc
						test_case.description = temp_desc
						# valid name found
						test_case.save
						state+=1
					end
				else
					test = parseIO(line)
					if test
						#test_cases.push(test)
						test.test_case_id = test_case.id
						test.save
					else
						temp_name = parseName(result)

						if temp_name
							test_case = TestCase.new
							test_case.assignment_id = assignment_id
							test_case.name = temp_name
							# valid name found
							state = 1
						end
					end
				end
			end				
		end
	end

private 

	def parseName(result)
		#value = Input.new
		value = nil
		if result[0][0] == "name"
			value = result[0][1]
		end
		return value
	end

	def parseDescription(result)
		#value = Input.new
		value = nil
		if result[0][0] == "description"
			value = result[0][1]
		end
		return value
	end

	def parseIO(result)
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
end
