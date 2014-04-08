class LoginController < ApplicationController
  include Login

  layout "login"

  def index
    @class = Student
    @student = Student.new
  end

  def new
    @user = Student.new
  end

  def create
    @user = Student.new(user_params(:student, :student_id))
    save(@user, login_url, params)
  end
end
