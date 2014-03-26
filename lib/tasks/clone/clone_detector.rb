require_relative '../manager'

class CloneIncident
    attr_accessor :first_file, :second_file, :similarity

    def initialize(first, second, similarity)
        @first_file = DiffFile.new(first)
        @second_file = DiffFile.new(second)
        @similarity = similarity
    end

    def to_s
        "first_file = #{@first_file}, second_file = #{@second_file}, similarity = #{@similarity}"
    end
end

class DiffFile
    attr_accessor :name, :content

    def initialize(name)
        @name = name
        @content = Array.new
    end

    def to_s
        "name = #{@name}, content = #{@content}"
    end
end

class DiffEntry
    attr_accessor :position, :lines

    def initialize(position)
        @position = position
        @lines = Array.new
    end

    def to_s
        "position = #{@position}, lines = #{@lines}"
    end
end

class CloneDetector < Manager

    CLONE_PARSER = /(.*?.cpp) consists for ([0-9]{1,3} %) of (.*.cpp) material/

    #This could break if they have a line similar to the output file
    #[0] => first file path, [1] = first line location, [2] => second file path, [3] => second line location, [4] => diff percent
    CLONE_DIFF_PARSER = /(.*?.cpp): line ([0-9\-]+)\s*\|(.*?.cpp): line ([0-9\-]+)[\s]*\[([0-9]+)\]/
    COMMAND = 'sim_c'
    OPTIONS = '-e -n -P -R -T -t 1 -r 12'
    OPTIONS_DIFF = "-T -t 1 -r 12"
    OUTPUT = '>'
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
        result = %x(#{COMMAND} #{OPTIONS} #{@path_to_file})
        #{OUTPUT} #{FILE}

        result.each_line do |line|
               @output.push(line)
        end        

        # Delete the temp file created
        #File.delete(FILE)
        @output
    end

    def parseOutput

        incidents = Array.new
        @output.each do |line|
            #[0] == first file, [1] == percent similarity, [2] == second file
            parsed = line.scan(CLONE_PARSER)

            #first_file_name = line[0][0]
            #second_file_name = 
            #puts parsed
            incidents.push(CloneIncident.new(parsed[0][0], parsed[0][2], parsed[0][1]))
            
            #incidents[-1].diff = Array.new
            size = 0

            #puts incidents[-1]#.first_file.name
            #puts incidents[-1]#.second_file.name
            #a = gets
            diff_out = %x(#{COMMAND} #{OPTIONS_DIFF} #{incidents[-1].first_file.name} #{incidents[-1].second_file.name})
            #puts diff_out
            diff_out.each_line do |line|
                diff_parser = line.scan(CLONE_DIFF_PARSER)

				#puts line
               	#a = gets

                if diff_parser != []
                    size = line.split("|")[0].size
                    incidents[-1].first_file.content.push(DiffEntry.new(diff_parser[0][1]))
                    incidents[-1].second_file.content.push(DiffEntry.new(diff_parser[0][3]))
                else
                    f1_line = line[0..size-1]
                    f2_line = line[size+1..-1]

                    #puts f1_line
                    #puts f2_line
                    #a = gets

                    incidents[-1].first_file.content[-1].lines.push(f1_line)
                    incidents[-1].second_file.content[-1].lines.push(f2_line)
                end
            end

            #File.delete(FILE)
        
        end
        return incidents
    end
end

=begin

=end

cloneDetector = CloneDetector.new("../example_programs/cheating/")

cloneDetector.applyCloneDetection

incident = cloneDetector.parseOutput

puts incident