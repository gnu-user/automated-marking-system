require_relative 'manager'

class CloneDetector < Manager

	CLONE_PARSER = /(.*?.cpp) consists for ([0-9]{1,3} %) of (.*.cpp) material/
	COMMAND = 'sim_c'
	OPTIONS = '-e -n -P -R -T -t 1 -r 12'
	OPTIONS_DIFF = "-T -t 1 -r 12"
	OUTPUT = '2>'
  	FILE = 'clone_temp.txt'

	def checkDirectoryExist
		checkFileExist
	end

	def applyCloneDetection
		process
	end

	def process
		super

		@output = Array.new
    	%x(#{COMMAND} #{OPTIONS} #{@path_to_file} #{OUTPUT} #{FILE})

    	File.open(FILE, 'r').each_line do |line|
	   		@output.push(line)
	    end

	    # Delete the temp file created
	    File.delete(FILE)
	    @output
	end

	def parseOutput

		incidents = Array.new
		@output.each do |line|
			#[0] == first file, [1] == percent similarity, [2] == second file
			parsed = line.scan(CLONE_PARSER)

			incidents.push(CloneIncident.new(line[0][0], line[0][2], line[0][1]))
			
			incidents[-1].diff = Array.new
			
			%x(#{COMMAND} #{OPTIONS_DIFF} #{incidents[-1].first_file} #{incidents[-1].second_file} #{OUTPUT} #{FILE})
			File.open(FILE, 'r').each_line do |line|
	   			@incidents[-1].diff.push(line)
	   		end
	    end
		end
	end
end

class CloneIncident
	attr_accessor :first_file, :second_file, :similarity, :diff

	def(first, second, similarity)
		@first_file = first
		@second_file = second
		@similarity = similarity
	end
end