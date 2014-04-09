class AdminController < ApplicationController
	# TODO FOR ALL
	# handle Grades link for latest assignments (better define)
	# handle logout

  def index
    validate_admin
    latest_assignment
    # Get all the assignments
    @assignments = Assignment.all

    @assignments.each do |assignment|
      @submissions = Submission.find_all_by_assignment_id(assignment.id)
      assignment.submission_count = @submissions.size

      #submissions.each do |submission|
      #  assignment.avg_grade += submission.
      #end
    end
    # TODO handle all the links shown
    # handle review submission link
    # handle view assignment positing (go to latest assignment)
    # handle link to assignment page (for review)
    # handle link to grades for each finished assignment
    @review_submissions = 12
    @view_assignment = 9
    @resolve_issues = 2
  end

  def new
    validate_admin
    latest_assignment
    # TODO handle form submission and populating the db
    # handle add button
    # handle upload button
    # handle button submit assignment
    @assignment = Assignment.new
  end

  def grading
    validate_admin
    latest_assignment
    # TODO handle grades page using param[:id]

    @submissions = Submission.find_all_by_assignment_id(params[:id])
  end

  def cheat
    validate_admin
    latest_assignment
    # TODO handle cheating page using param[:id]
  end

  def show
    validate_admin
    latest_assignment

    @assignment = Assignment.find_by_id(params[:id])

    if @assignment == nil
      #TODO give error message
      #redirect_to "#{root_url}admin", :notice => "No Activity found!"
    end
  end

  def create
    validate_admin
    latest_assignment

    # TODO check if at least 1 evaluation testcase has been submitted
    @value = params.require(:assignment).permit(:name, :description, :posted, :due, :max_time, :attempts, :code_weight, :test_case_weight)
    #@value[:posted] = 
    @assignment = Assignment.new#(@value)
    @assignment.name = @value[:name]
    @assignment.description = @value[:description]

    @assignment.posted = fixDate(@value[:posted])
    @assignment.due = fixDate(@value[:due])
    @assignment.max_time = @value[:max_time]
    @assignment.attempts = @value[:attempts]
    @assignment.code_weight = @value[:code_weight]
    @assignment.test_case_weight = @value[:test_case_weight]
    @assignment.admin_id = session[:prof_id]
    @assignment.released = false

    if @assignment.save
      #Create the new TestCase Sample and TestCase Eval
      session[:assignment_id] = @assignment.id 
    else
      redirect_to "#{root_url}admin/new"
    end
  end

  def upload
    validate_admin
    latest_assignment

    @contents = params[:file].read

    if !TestCase.parseYaml(@contents, session[:assignment_id])
      # TODO show an error
      redirect_to "#{root_url}"
    end
  end

  def submit
    validate_admin
    latest_assignment

    if TestCase.where("assignment_id = #{session[:assignment_id].to_i} AND sample = 't'").count > 0
    else
      # TODO report error
      redirect_to "#{root_url}" 
    end

    # Set the assignment as released so when the posted date passes it will show up for the students
    assignment = Assignment.find_by_id(session[:assignment_id])
    assignment.released = true

    #TODO catch an error if there is one
    assignment.save

  end

  private

  def validate_admin
    @user = Admin.find_by_id(session[:prof_id])

    if @user == nil
      # User not logged in
      redirect_to "#{root_url}admin/login", :notice => "Sign in first!"
    end
  end

  def latest_assignment
    @latest = Assignment.last
  end

  # Fix the date to be in the expected order 
  # Bootstrap outputs mm/dd/yyyy hh:mm
  # Rails is expecting dd/mm/yyyy hh:mm
  # Swap the day and month and everything works
  def fixDate(date)
    temp = date.scan(/([0-9]+)\/([0-9]+)\/(.*)/)
    if temp.size == 1 && temp[0].size == 3
      return "#{temp[0][1]}/#{temp[0][0]}/#{temp[0][2]}"
    end

    return nil
  end
end
