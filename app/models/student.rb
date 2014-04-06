class Student < ActiveRecord::Base

  attr_accessor :password, :last_name, :first_name, :email, :student_id, :password_confirmation
  before_save :encrypt_password

  validates :password, :confirmation => true

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :student_id
  validates_uniqueness_of :student_id

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

end
