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
		@user = Admin.new(params[:admin])

		if @user.save!
	      redirect_to root_url, :notice => "Signed up!"
	    else
	      render "new"
	    end
	end
end
