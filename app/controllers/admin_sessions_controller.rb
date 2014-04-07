class AdminSessionsController < ApplicationController

  def create
    user = Admin.authenticate(params[:admin][:email], params[:admin][:password])
    if user
      session[:prof_id] = user.id
      redirect_to "#{root_url}admin", :notice => "Logged in!"
    else
      #TODO show error message
      flash.now.alert = "Invalid email or password"
      redirect_to "#{root_url}admin/login"
    end
  end

  def destroy
  	session[:prof_id] = nil
    redirect_to "#{root_url}admin/login", :notice => "Logged out!"
  end
end
