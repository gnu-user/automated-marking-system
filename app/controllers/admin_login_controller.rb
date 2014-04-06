class AdminLoginController < ApplicationController
	layout "login"

	def index
		# TODO handle login logic
	end

	def new
		# TODO Handle registration logic
		@user = Admin.new
	end

	def create
		@user = Admin.new(user_params)

		if @user.save!
	      redirect_to admin_login_url, :notice => "Signed up!"
	    else
	      render "new"
	    end
	end

  def user_params
      params.require(:admin).permit(:first_name, :last_name, :prof_id, :email, :password, :password_confirmation)
  end
end
