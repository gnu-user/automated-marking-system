class TestCase < ActiveRecord::Base
	belongs_to :assignment
	has_many :inputs

	#attr_accessor :testcase

	#TODO test
	# Returns true if it was successful in parsing and saving
	# otherwise returns false
	def self.parseYaml(test_cases, assignment_id)
		state = 0
		test_case = Array.new
		#Parse the YAMl
		testcase.split(/(\n\r)|\r|\n/).each do |line|
			# 1. Test name
			# 2. Test description
			# 3. Test sample
			# 4. Test ParseIO

			result = line.scan(/(.*): (.*)/)
			if result.size > 0 && result[0].size == 2
				if result[0][0] != nil
					if state == 0
						temp_name = parseName(result)

						if temp_name
							test_case.push(TestCase.new)
							test_case[-1].assignment_id = assignment_id
							test_case[-1].name = temp_name
							# valid name found
							state+=1
						else
							return false
						end
					elsif state == 1
						temp_desc = parseDescription(result)

						if temp_desc
							test_case[-1].description = temp_desc
							# valid name found
							
							state+=1
						else
							return false
						end

					elsif state == 2
						temp_sample = parseSample(result)

						if temp_sample
							test_case[-1].sample = temp_sample

							state+=1
						else
							return false
						end
					else
						test = parseIO(line)
						if test
							#test_cases.push(test)
							test.test_case_id = test_case[-1].id
							test.save
						else
							temp_name = parseName(result)

							if temp_name
								test_case.push(TestCase.new)
								test_case[-1].assignment_id = assignment_id
								test_case[-1].name = temp_name
								# valid name found
								state = 1
							else
								return false
							end
						end
					end
				end
			end				
		end

		test_case.each do |testcase|
			testcase.save
		end
		return true
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

	def parseSample(result)
		#value = Input.new
		value = nil
		if result[0][0] == "sample"
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
