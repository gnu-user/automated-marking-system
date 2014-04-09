require "#{Rails.root}/lib/tasks/lint/lint_manager"
require "#{Rails.root}/lib/tasks/compiler/compile_manager"
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

    sub = Submission.where("student_id = #{student_id} AND assignment_id = #{assignment_id}")[0]

    @program = sub.code

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

    @results = nil
    @output = nil


    file = File.new("#{student_id}_#{assignment_id}",'w')
    file.puts(@program)
    file.close

    begin

      lintManager = LintManager.new(file.path)
      lintManager.process
      lintManager.parseOutput(@grade.id)
      #@path = "#{Rails.root}/lib/tasks/compiler/compile_manager"
      #@results = File.exists?("#{@path}.rb")
      #compileManager = CompileManager.new(file.path)
      #@results = compileManager.process

      #@results.each do |result|
      #  StaticAnaylsis.create!({
      #     filename: file.path,
      #      grade_id: @grade.id
      #    })
      #  StaticIssue.create!({

      #    })
      #end

    ensure
      #tmp.close
      File.delete(file.path)
      #tmp.unlink
    end

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