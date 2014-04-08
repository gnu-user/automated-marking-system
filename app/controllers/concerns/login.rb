module Login
  private


  def save(user, post_url, params)
    if params[:t_and_c] && params[:t_and_c] === 1
      if user.save
        redirect_to post_url, notice: "Signed up!"
      else
        redirect_to post_url, flash: {register: user.errors}
      end
    else
      redirect_to post_url, flash: {alert: "Please Accept Terms & Conditions"}
    end
  end

  def user_params(type, id)
    params.require(type).permit(:first_name, :last_name, id, :email, :password, :password_confirmation)
  end
end
