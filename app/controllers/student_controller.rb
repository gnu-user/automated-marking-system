class StudentController < ApplicationController
  layout "student"
  layout "code", only: [:show]

    # TODO FOR ALL (except show)
    # handle Grades link for latest finished assignments
    # handle logout

  def index
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
  	# TODO handle showing latest grade
  	# Show grade for the activiy related to id stored in 'param[:id]'
  end
end