class AdminController < ApplicationController
	# TODO FOR ALL
	# handle Grades link for latest assignments (better define)
	# handle logout

  def index
    # TODO handle all the links shown
    # handle review submission link
    # hanlde view assignment positing (go to latest assignment)
    # handle link to assignment page (for review)
    # handle link to grades for each finished asssignment
    @review_submissions = 12
    @view_assignment = 9
    @resolve_issues = 2
  end

  def new
    # TODO handle form submission and populating the db
    # handle add button
    # handle upload button
    # handle button submit assignment
  end

  def grading
    # TODO handle grades page using param[:id]
  end

  def cheat
    # TODO handle cheating page using param[:id]
  end

  def show
    # TODO handle displaying the relavent information about the active assignment
  end
end
