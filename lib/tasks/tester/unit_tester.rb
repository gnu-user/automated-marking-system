require_relative '../manager'
#require_relative 'test'
#require_relative 'io_element'

class UnitTester < Manager
    attr_accessor :testCases

    FILE_FLAG = "r+"

    # testCases is a list of Test elements.
    def initialize(path="", testCases, grade_id, max_execution_time)
        super(path)
        @testCases = testCases
        @grade_id = grade_id
        @max_exec = max_execution_time
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
        while pid.alive? && count < 60#@max_exec
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

    def process
        super

        Dir.chdir("#{Rails.root}/lib")
        #@count = 0
        testCases.each do |testCase|
            #return Dir.pwd
            io = IO.popen("../#{@path_to_file}", FILE_FLAG)
            result = true

            #puts testCase.ioList
            Input.where("test_case_id = #{testCase.id}").each do |ioElement|
                #how << "Inside"
                begin
                    #how << ioElement.value
                    if ioElement.input
                        io.puts ioElement.value
                    else
                        # Check if result == ioElement.value
                        result = getOutput(ioElement.value, io)
                    end
                rescue Exception => e
                    # Catch any exception
                    #puts e
                    #how << e
                    result = false
                end
            end

            io.close

            exitCode = $?
            if !exitCode.success?
                #how << "Exit code bad"
                result = false
            end

            #TODO delete/update previous testcase run
            studentTest = Test.where("grade_id = #{@grade_id} and test_case_id = #{testCase.id}")

            if studentTest.empty?
                studentTest = Test.new
                studentTest.grade_id = @grade_id
                studentTest.test_case_id = testCase.id
                studentTest.result = result
                studentTest.save
            else
                studentTest = studentTest[0]
            end
        end
        # Delete the .o file.
        Dir.chdir(Rails.root)
        File.delete(@path_to_file)
    end
end