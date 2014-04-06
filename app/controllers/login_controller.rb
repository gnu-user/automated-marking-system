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

		@value = params.require(:student).permit!#(:first_name, :last_name, :student_id, :email, :password, :password_confirmation)
		@user = Student.new(@value)

		#@value = 

		if @user.save
		  redirect_to "#{root_url}/student"
	      #redirect_to root_url, :notice => "Signed up!"
	    else
	      render "new"
	   	end
	end

	#private

  #def user_params
    
  #end
end
