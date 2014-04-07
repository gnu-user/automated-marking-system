module User extend ActiveSupport::Concern
  included do
    attr_accessor :password, :password_confirmation
    before_save :encrypt_password
    after_save :clear_password

    validates_confirmation_of :password
    validates_presence_of :password, on: :create
  end

  private

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
