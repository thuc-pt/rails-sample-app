module SessionsHelper
  def login user
    session[:user] = user.id
  end

  def remember user
    user.remember_digest_token
    cookies.permanent.signed[:user] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget_token
    cookies.delete :user
    cookies.delete :remember_token
  end

  def current_user
    if session[:user]
      User.find_by id: session[:user]
    elsif cookies.signed[:user]
      user = User.find_by id: cookies.signed[:user]
      if user&.authenticate?(:remember, cookies[:remember_token])
        login user
        user
      end
    end
  end

  def signout
    forget current_user
    session.delete :user
  end
end
