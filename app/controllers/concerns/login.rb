module Login
  private

  def save(user, post_url)
    if user.save
      redirect_to post_url, notice: "Signed up!"
    else
      redirect_to post_url
    end
  end

  def user_params(user)
    id = :"#{user}_id"

    params.require(user).permit(:first_name, :last_name, id, :email, :password, :password_confirmation)
  end
end
