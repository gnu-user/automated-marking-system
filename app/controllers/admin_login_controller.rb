class AdminLoginController < ApplicationController
  include Login

	layout "login"

	def index
		# TODO handle login logic
    @admin = Admin.new
	end

	def new
		# TODO Handle registration logic
		@user = Admin.new
	end

	def create
    #@value = params[:admin]
		@user = Admin.new(user_params(:admin))
    save(@user, admin_login_url)
	end
end
