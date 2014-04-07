class Student < ActiveRecord::Base
  include User

  validates_presence_of :student_id
  validates_uniqueness_of :student_id

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
end
