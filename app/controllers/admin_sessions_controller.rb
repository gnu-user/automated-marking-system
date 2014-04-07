class AdminSessionsController < UserSessionsController

  def initialize
    super(Admin, :admin, :prof_id)
  end

  def create
    UserSessionsController.instance_method(:create).bind(self).call(admin_url, admin_login_url)
  end

  def destroy
    UserSessionsController.instance_method(:destroy).bind(self).call(admin_login_url)
  end
end
