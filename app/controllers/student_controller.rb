##############################################################################
#
# Automated Marking System (AMS)
# 
# A scalable automated marking system that provides automated marking, quality
# feedback, and cheating detection all in one easy to use solution.
#
#
# Copyright (C) 2014, Joseph Heron, Jonathan Gillett, Daniel Smullen, 
# and Khalil Fazal
# All rights reserved.
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
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
    getHeaderInfo(false)
    # TODO handle links for finished assignments
    # TODO handle links for active assignments
    # TODO handle grade links for finished assignments
    #@assignments = Assignment.all

    @assignments = ActiveRecord::Base.connection.execute("SELECT datetime('now') >= assignments.posted as post, datetime('now') < assignments.due as duedate, assignments.id as id, assignments.name as name, assignments.posted as posted, assignments.due as due, assignments.id as assignment_id, grades.final as final FROM assignments LEFT OUTER JOIN submissions ON assignments.id = submissions.assignment_id LEFT OUTER JOIN students ON students.id = submissions.student_id LEFT OUTER JOIN grades ON submissions.id = grades.submission_id WHERE students.id is null or students.id = #{session[:user_id].to_i}")

    # TODO fix left so that it only accounts for assignments posted
    left = 0
    graded = 0
    error = 0

    # TODO add pass submission date
    @assignments.each do |assignment|

      if assignment["final"]
        graded+=1
        assignment["class"] = "success"
      elsif assignment["post"] == 1 && assignment["duedate"] == 1
        left+=1
        assignment["class"] = "warning"
      elsif assignment["post"] == 1 && assignment["duedate"] == 0
        error+= 1
        assignment["class"] = "danger"
      end
    end

    @assignment = {
        # TODO Generate the number of assignments graded
        graded: graded,
        # TODO Generate the number of assignments not submitted
        left: left,
        # TODO Generate the number of assignments submission errors
        error: error
    }
  end

  def test
    validateUser
    getHeaderInfo(false)

    student_id = session[:user_id]
    assignment_id = params[:id]

    max_time = Assignment.find_by_id(assignment_id).max_time

    testcases = TestCase.where("assignment_id = #{assignment_id.to_i}")

    sub = Submission.where("student_id = #{student_id} AND assignment_id = #{assignment_id.to_i}")[0]

    @grade = Grade.where("submission_id = #{sub.id}")
    #@program = sub.code

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
      else
        testcases.each do |testcase|
          Test.where("grade_id = #{@grade.id} and test_case_id = #{testcase.id}").delete_all
        end
        
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
    getHeaderInfo(false)

    @assignment = Assignment.find_by_id(params[:id])
  
    getAssignmentFeedback(@assignment.id, student_id)

    @title = @assignment.name
  end

  def submit
    validateUser
    getHeaderInfo(false)

    student_id = session[:user_id]
    assignment_id = params[:id]

    assignment = Assignment.find_by_id(assignment_id)

    sub = Submission.where("student_id = #{student_id} AND assignment_id = #{assignment_id.to_i}")[0]

    @grade = Grade.where("submission_id = #{sub.id}")

    if @grade != nil && @grade.empty?
      # Tell them that they must submit an assignment
      redirect_to "#{root_url}student/assignment/#{assignment_id.to_i}"
    else
      @grade = @grade[0]
    end

    if sub.submit_count == nil
      sub.submit_count = 0
    end

    if sub.submit_count < assignment.attempts

      # Calculate the grade for the test_case mark
      tests = ActiveRecord::Base.connection.execute("SELECT tests.result FROM tests, test_cases WHERE tests.grade_id = #{@grade.id} and tests.test_case_id = test_cases.id and test_cases.sample = \'f\'")
      
      @grade.testcase = 0
      if !tests.empty?
        tests.each do |rval|
          if rval
            @grade.testcase += 1
          end
        end
        
        @grade.testcase = (@grade.testcase / sampleTests.size) * 100
      end

      # Get the static analysis and test case weights for the final grade calculation
      code_weight = assignment.code_weight / 100.0
      test_case_weight = assignment.test_case_weight / 100.0      
      @grade.final = @grade.code * code_weight + @grade.testcase * test_case_weight

      sub.submit_count += 1

      @grade.save
      sub.save
    end

    redirect_to "#{root_url}student/"
  end

  def submission
    validateUser
    getHeaderInfo(false)

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
    #getHeaderInfo(false)

    assignment_id = params[:id].to_i

    submission = Submission.where("assignment_id = #{assignment_id} and student_id = #{session[:user_id].to_i}")
    # TODO get the code and populate the %pre element, id='code'
    if !submission.empty?
      @code = submission[0].code
    else
      # redirect to error
    end
  end

  def grading
    validateUser
    getHeaderInfo(true)

    student_id = session[:user_id].to_i
    assignment_id = params[:id].to_i

    @assignment = Assignment.find_by_id(assignment_id)

    getAssignmentFeedback(assignment_id, student_id)
    #submission = Submission.where("assignment_id = #{params[:id].to_i} and student_id = #{session[:user_id].to_i}")
  end

  private

  def getHeaderInfo(onGrades)
    @lastest = ActiveRecord::Base.connection.execute("select assignments.id as assignment_id from assignments, submissions, grades where assignments.id = submissions.assignment_id and grades.submission_id = submissions.id order by assignments.created_at LIMIT 1")

    if @lastest != nil && !@lastest.empty?
      @lastest = @lastest[0]
    end

    #@lastest = Assignment.order("created_at").last.id
    @onGrades = onGrades
  end

  def validateUser
    @user = Student.find_by_id(session[:user_id])

    if @user == nil
      # User not logged in
      redirect_to root_url, :notice => "Sign in first!"
    end
  end

  def getAssignmentFeedback(assignment_id, student_id)

    submission = Submission.where("student_id = #{student_id.to_i} AND assignment_id = #{assignment_id.to_i}")

    if submission.empty?
      return nil
    else
      submission = submission[0]
    end

    @static_issues = []
    @compiler_issues = []
    @test_cases = []

    if submission != nil

      # Get the related static issues
      @static_issues = ActiveRecord::Base.connection.execute("select static_analyses.filename as filename, static_issues.line_number as line_number, static_issues.description as description, static_issues.type as type from grades, static_analyses, static_issues where grades.submission_id = #{submission.id} and grades.id = static_analyses.grade_id and static_analyses.id = static_issues.static_analysis_id")

      # Get the related compiler issues
      @compiler_issues = ActiveRecord::Base.connection.execute("select compiler_issues.filename as filename, issues.method as method, issues.line_number as line_number, issues.col_number as col_number, issues.issue_type as issue_type, issues.message as message, issues.relavent_code as relavent_code from grades, compiler_issues, issues where grades.submission_id = #{submission.id} and grades.id = compiler_issues.grade_id and compiler_issues.id = issues.compiler_issue_id")

      # Get the related tests cases
      @test_cases = ActiveRecord::Base.connection.execute("select tests.result as result, test_cases.name as name, test_cases.description as description, test_cases.id as test_case_id from grades, tests, test_cases where grades.submission_id = #{submission.id} and grades.id = tests.grade_id and tests.test_case_id = test_cases.id and test_cases.sample = \'t\'")

      if @test_cases
        @test_cases.each do |tcase|
          tcase["values"] = ActiveRecord::Base.connection.execute("select inputs.value as value, inputs.input as input from test_cases, inputs where test_cases.sample = \'t\' and test_cases.id = inputs.test_case_id and test_cases.id = #{tcase["test_case_id"]}")
        end
      end
    end
  end

end