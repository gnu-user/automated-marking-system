class AdminController < ApplicationController
  @grading = false
	# TODO FOR ALL
	# handle Grades link for latest assignments (better define)
	# handle logout

  def index
    # TODO handle all the links shown
    # handle review submission link
    # hanlde view assignment positing (go to latest assignment)
    # handle link to assignment page (for review)
    # handle link to grades for each finished asssignment
  end

  def new
    # TODO handle form submission and populating the db
    # handle add button
    # handle upload button
    # handle button submit assignment
  end

  def grading
  	@grading = true
    # TODO handle grades page using param[:id]
  end

  def cheat
    # TODO handle cheating page using param[:id]
  end

  def show
    # TODO handle displaying the relavent information about the active assignment
  end
end
