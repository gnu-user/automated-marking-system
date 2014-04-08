require "#{Rails.root}/lib/tasks/lint/lint_manager"
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
    student_id = session[:user_id]
    assignment_id = params[:id]

    program = Submission.where("student_id = #{student_id} AND assignment_id = #{assignment_id}")[0].code

    tmp = Tempfile.new "#{student_id}_#{assignment_id}"

    @results = nil

    begin
      tmp.write(program)

      @results = LintManager.new(tmp.path).process
    ensure
      tmp.close
      tmp.unlink
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

    Submission.create!({
        code: contents,
        assignment_id: params[:id],
        student_id: session[:user_id]
    })

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