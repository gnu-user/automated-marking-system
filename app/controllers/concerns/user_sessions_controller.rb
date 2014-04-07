class UserSessionsController < ApplicationController
  def initialize(controller, type, id)
    @controller = controller
    @type = type
    @id = id
  end

  def create(landing_page, post_logout_page)
    user = @controller.authenticate(params[@type][:email], params[@type][:password])

    if user
      session[@id] = user.id
      redirect_to landing_page, notice: "Logged in!"
    else
      flash[:alert] = "Invalid email or password"
      redirect_to post_logout_page
    end
  end

  def destroy(post_logout_page)
    session[type] = nil
    redirect_to post_logout_page, notice: "Logged out!"
  end
end