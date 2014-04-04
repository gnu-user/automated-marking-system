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
  end

  def grading
  	# TODO handle showing latest grade
  	# Show grade for the activiy related to id stored in 'param[:id]'
  end
end
