class LoginController < ApplicationController
  include Login

  layout "login"

  def index
    # TODO handle login logic
    @student = Student.new
  end

  def new
    # TODO Handle registration logic
    @user = Student.new
  end

  def create
    #@value = params[:student]
    @user = Student.new(user_params(:student))
    save(@user, root_url)
  end
end
