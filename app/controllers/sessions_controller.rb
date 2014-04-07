class SessionsController < UserSessionsController
  def initialize
    super(Student, :student, :user_id)
  end

  def create
    UserSessionsController.instance_method(:create).bind(self).call(student_url, login_url)
  end

  def destroy
    UserSessionsController.instance_method(:destroy).bind(self).call(login_url)
  end
end
