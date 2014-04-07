class SessionsController < ApplicationController
  #def new
  #	create
  #end

  def create
    user = Student.authenticate(params[:student][:email], params[:student][:password])
    if user
      session[:user_id] = user.id
      redirect_to student_url, :notice => "Logged in!"
    else
      #TODO show error message
      flash[:alert] = "Invalid email or password"
      redirect_to login_url
    end
  end

  def destroy
  	session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
