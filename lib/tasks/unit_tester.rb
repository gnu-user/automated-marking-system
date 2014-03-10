require_relative 'io_element.rb'

io = IO.popen("./Example", "r+")
io.puts 1
io.puts 2
result = io.readline.to_i

io.close

class UnitTester
    attr_accessor :path, :testCases

    FILE_FLAG = "r+"

    def initialize(path="", testCases=Array.new)
        @path = path
        @testCases = testCases
    end

    def process()
        testCases.each do |testCase|
            
            io = IO.popen(path, FILE_FLAG)
            test = true
            
            testCase.each do |ioElement|

                begin
                    if ioElement.input
                        io.puts ioElement.value
                    else
                        # Check if result == ioElement.value
                        
                        result = ""

                        # Prevent deadlock if no output is provided
                        pid = Thread.new do
                            result = io.readline
                        end

                        valid = true
                        count = 0

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
                            if result != ioElement.value
                                # Incorrect return value
                                test = false
                            end
                        else
                            # Invalid return
                            test = false
                        end
                    end
                rescue Exception => e
                    # Catch any exception
                    puts e
                    test = false
                end
            end
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