class LoginController < ApplicationController
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
		@value = user_params
		@user = Student.new(@value)

		if @user.save!

		  redirect_to root_url, :notice => "Signed up!"
	    else
	      render "new"
	   	end
	end

	private

	def user_params
    	params.require(:student).permit(:first_name, :last_name, :student_id, :email, :password, :password_confirmation)
	end
end
