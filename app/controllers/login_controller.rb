class LoginController < ApplicationController
  include Login

  layout "login"

  def index
    @student = Student.new
  end

  def new
    @user = Student.new
  end

  def create
    #@value = params[:student]
    @user = Student.new(user_params(:student, :student_id))
    save(@user, root_url)
  end
end
