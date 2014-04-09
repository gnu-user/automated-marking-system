require "#{Rails.root}/lib/tasks/lint/lint_manager"
require "#{Rails.root}/lib/tasks/compiler/compile_manager"
require "#{Rails.root}/lib/tasks/tester/unit_tester"
require 'tempfile'

class StudentController < ApplicationController
  layout "student"
  layout "code", only: [:show]

  # TODO FOR ALL (except show)
  # handle Grades link for latest finished assignments  

  def index
    validateUser
    # TODO handle links for finished assignments
    # TODO handle links for active assignments
    # TODO handle grade links for finished assignments
    @assignments = Assignment.all

    @assignment = {
        # TODO Generate the number of assignments graded
        graded: 2,
        # TODO Generate the number of assignments not submitted
        left: 1,
        # TODO Generate the number of assignments submission errors
        error: 1
    }
  end

  def test
    validateUser
    student_id = session[:user_id]
    assignment_id = params[:id]

    max_time = Assignment.find_by_id(assignment_id).max_time

    testcases = TestCase.where("assignment_id = #{assignment_id.to_i}")

    sub = Submission.where("student_id = #{student_id} AND assignment_id = #{assignment_id.to_i}")[0]

    #@program = sub.code

    @grade = Grade.where("submission_id = #{sub.id}")

    # Create a new grade if needed
    if @grade.empty?
      @grade = Grade.new
      @grade.submission_id = sub.id 
      @grade.save
    else
      @grade = @grade[0]
    end

    #tmp = Tempfile.new "#{student_id}_#{assignment_id}"

    #@results = nil
    #@output = nil

    fileName = "#{student_id}_#{assignment_id}"
    file = File.new("#{fileName}.cpp",'w')
    file.puts(sub.code)
    file.close

    begin

      # The initial grade for static issues is 100, a half mark taken off (5) for
      # each style issue and a full mark (10) for errors
      static_mark = 100

      # Run static analysis
      lintManager = LintManager.new(file.path)
      lintManager.process
      @static_issues = lintManager.parseOutput(@grade.id)

      @static_issues.each do |issue|
        if issue == "error"
          static_mark -= 10
        else
          static_mark -= 5
        end
      end

      # Store the grade for the static analysis mark
      @grade.code = static_mark > 0 ? static_mark : 0
      @grade.save

      # Run the compiler
      compileManager = CompilerManager.new(file.path)
      value = compileManager.process
      @compiler_issues = compileManager.parseOutput(@grade.id)

      # if the program didnt compile then the test cases will all fail, don't attempt
      if value
        #@value = "HERE"
        unitTester = UnitTester.new("#{fileName}.cpp.o", testcases, @grade.id, max_time)
        unitTester.process
      end

    ensure
      #tmp.close
      File.delete("#{Rails.root}/#{file.path}")
      #tmp.unlink
    end

    redirect_to "#{root_url}student/assignment/#{assignment_id}"

    # TODO: store results in database, redirect back to assignment page
  end

  def assignment
    validateUser

    @assignment = Assignment.find_by_id(params[:id])
    @submission = Submission.where("student_id = #{session[:user_id].to_i} AND assignment_id = #{params[:id].to_i}")

    @title = @assignment.name

    # TODO Show activity related to id stored in 'param[:id]'
    # TODO handle upload submission on click
    # TODO handle test on click
    # TODO handle submit on click
  end

  def submit
    validateUser
    student_id = session[:user_id]
    assignment_id = params[:id]

    assignment = Assignment.find_by_id(assignment_id)

    sub = Submission.where("student_id = #{student_id} AND assignment_id = #{assignment_id.to_i}")[0]

    @grade = Grade.where("submission_id = #{sub.id}")

    if @grade.empty?
      # Tell them that they must submit an assignment
    else
      @grade = @grade[0]
    end

    if sub.submit_count == nil
      sub.submit_count = 0
    end

    if sub.submit_count <= assignment.attempts

      # Calculate the grade for the test_case mark
      sampleTests = ActiveRecord::Base.connection.execute("SELECT tests.result FROM tests, test_cases WHERE tests.grade_id = #{@grade.id} and tests.test_case_id = test_cases.id and test_cases.sample = \'f\'")
      
      @grade.testcase = 0
      if !sampleTests.empty?
        sampleTests.each do |rval|
          if rval
            @grade.testcase += 1
          end
        end
        
        @grade.testcase = (@grade.testcase / sampleTests.size) * 100

      	# Get the static analysis and test case weights for the final grade calculation
      	code_weight = assignment.code_weight / 100.0
      	test_case_weight = assignment.test_case_weight / 100.0      
      	@grade.final = @grade.code * code_weight + @grade.testcase * test_case_weight
      end

      sub.submit_count += 1

      @grade.save
      sub.save
    end

    redirect_to "#{root_url}student/"
  end

  def submission
    validateUser

    contents = params[:file].read

    submission = Submission.where("assignment_id = #{params[:id].to_i} and student_id = #{session[:user_id].to_i}")

    if submission.empty?
      Submission.create!({
        code: contents,
        assignment_id: params[:id],
        student_id: session[:user_id]
      })
    else
      submission[0].code = contents
      submission[0].save
    end

    redirect_to student_assignment_url
  end

  def show
    validateUser
    # TODO get the code and populate the %pre element, id='code'
    @code = "cout << \"winning\" << endl;"
  end

  def grading
    validateUser
    # TODO handle showing latest grade
    # Show grade for the activiy related to id stored in 'param[:id]'
  end

  private

  def validateUser
    @user = Student.find_by_id(session[:user_id])

    if @user == nil
      # User not logged in
      redirect_to root_url, :notice => "Sign in first!"
    end
  end

end