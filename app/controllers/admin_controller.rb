class AdminController < ApplicationController
	# TODO FOR ALL
	# handle Grades link for latest assignments (better define)
	# handle logout

  def index
    validateAdmin
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
    validateAdmin
    # TODO handle form submission and populating the db
    # handle add button
    # handle upload button
    # handle button submit assignment
    @assignment = Assignment.new
  end

  def grading
    validateAdmin
    # TODO handle grades page using param[:id]
  end

  def cheat
    validateAdmin
    # TODO handle cheating page using param[:id]
  end

  def show
    validateAdmin
    # TODO handle displaying the relavent information about the active assignment
  end

  def create
    validateAdmin
    # TODO check if at least 1 evaluation testcase has been submitted
    @value = params.require(:assignment).permit(:name, :description, :posted, :due, :max_time, :attempts, :code_weight, :test_case_weight)
    @assignment = Assignment.new(@value)
    @assignment.admin_id = session[:prof_id]
    #save(@user, root_url)
    if @assignment.save
      #Create the new TestCase Sample and TestCase Eval
      session[:assignment_id] = @assignment.id 
      @test_sample = TestCase.new
      #@test_sample.assignment_id = @assignment_id
      @test_sample.sample = false
      @test_eval = TestCase.new
      @test_eval.sample = true
      #redirect_to post_url, notice: "Signed up!"
    else
      redirect_to "#{root_url}admin/new"
    end
  end

=begin
  def test_sample_add
    validateAdmin
    @test = params.require(:test_case).permit(:name, :description, :sample, :testcase, :assignment_id)
    @test_sample = TestCase.new(@test)
    @test_sample.assignment_id = session[:assignment_id]
    @test_sample.sample = true
  
    if @test_sample.save

    else
      redirect_to "#{root_url}admin/new"
    end
  end

  def test_eval_add

  end
=end

  private

def validateAdmin
    @user = Admin.find_by_id(session[:prof_id])

    if @user == nil
      # User not logged in
      redirect_to "#{root_url}admin/login", :notice => "Sign in first!"
    end
  end
end
