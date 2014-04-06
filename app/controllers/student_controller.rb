class StudentController < ApplicationController
  layout "student"
  layout "code", only: [:show]

    # TODO FOR ALL (except show)
    # handle Grades link for latest finished assignments
    # handle logout

  def index
    validate
    # TODO handle student page layout
    # handle links for finished assignments
    # handle links for active assignments
    # handle grade links for finished assignments
    # Generate the number of assignments graded
    # Generate the number of assignments not submitted
    # Generate the number of assignments submission errors
    @assignmnet_graded = 2
    @assignment_left = 1
    @assignment_error = 1
  end

  def assignment 
    validate
  	# TODO handle active assignment
  	# Show activity related to id stored in 'param[:id]'
  	# handle upload submission on click
  	# handle test on click
  	# handle submit on click
  end

  def show
  	# TODO get the code and populate the %pre element, id='code'
    @code = "cout << \"winning\" << endl;"
  end

  def grading
    validate
  	# TODO handle showing latest grade
  	# Show grade for the activiy related to id stored in 'param[:id]'
  end

private

  def validate
    @user = Student.find_by_id(session[:user_id])

    if @user == nil
      # User not logged in
      redirect_to root_url, :notice => "Sign in first!"
    end
  end

end