class Admin < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  before_save :encrypt_password
  after_save :clear_password

  validates :password, confirmation: true

  validates_confirmation_of :password
  validates_presence_of :password, on: :create
  validates_presence_of :prof_id
  validates_uniqueness_of :prof_id

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def clear_password
    self.password = nil
    self.password_confirmation = nil
  end
end
