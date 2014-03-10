require_relative 'test.rb'
require_relative 'io_element.rb'

class UnitTester
    attr_accessor :path, :testCases

    FILE_FLAG = "r+"

    # testCases is a list of Test elements.
    def initialize(path="", testCases=Array.new)
        @path = path
        @testCases = testCases
    end

    def getOutput(expected, io)
        result = ""
        test = true
        valid = true
        count = 0

        # Prevent deadlock if no output is provided
        pid = Thread.new do
            result = io.gets.chomp
        end        

        # Wait until the thread sleeps or a 60 second timeout
        while pid.alive? && count < 60
            sleep(1)
            if pid.status == "sleep"
                pid.kill
                # Bad output
                valid = false
            end
            count +=1
        end

        # Ensure the thread is dead
        if pid.alive?
            pid.kill
        end

        if valid
            # Valid return
            #puts result
            #puts expected
            if result != expected.to_s
                # Incorrect return value
                test = false
            end

        else
            # Invalid return
            test = false
        end
        return test
    end

    def process()
        testCases.each do |testCase|
            
            io = IO.popen(path, FILE_FLAG)
            test = true

            #puts testCase.ioList

            testCase.ioList.each do |ioElement|

                begin
                    if ioElement.input
                        io.puts ioElement.value
                    else
                        # Check if result == ioElement.value
                        test = getOutput(ioElement.value, io)
                    end
                rescue Exception => e
                    # Catch any exception
                    puts e
                    test = false
                end
            end

            io.close

            exitCode = $?
            if !exitCode.success?
                test = false
            end

            testCase.result = test
        end
    end
end

#class TestCase
    #IO list must be ordered
#    attr_accessor :ioList

#    def initialize(list=Array.new)
#        @ioList = list
#    end
#end

=begin
test = Test.new

test.name = "Add default"
test.description = "Add two numbers"
test.result = false
test.ioList = Array.new

test.ioList.push(IOElement.new(1, true))
test.ioList.push(IOElement.new(2, true))
test.ioList.push(IOElement.new(3, false))

testers = Array.new

testers.push(test)

utester = UnitTester.new("example_programs/Example", testers)

utester.process

puts test
=end

#io = IO.popen("./Example", "r+")
#io.puts 1
#io.puts 2
#result = io.readline.to_i

#io.close