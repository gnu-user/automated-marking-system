class Admin < ActiveRecord::Base
  include User

  validates_presence_of :prof_id
  validates_uniqueness_of :prof_id

  has_many :assignments
  has_many :test_cases, :through => :assignments
  has_many :inputs, :through => :test_cases
  #has_many :students
  

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
end
