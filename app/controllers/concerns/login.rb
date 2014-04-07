module Login
  private

  def save(user, post_url)
    if user.save
      redirect_to post_url, notice: "Signed up!"
    else
      redirect_to post_url, flash: {register: user.errors}
    end
  end

  def user_params(type, id)
    params.require(type).permit(:first_name, :last_name, id, :email, :password, :password_confirmation)
  end
end
