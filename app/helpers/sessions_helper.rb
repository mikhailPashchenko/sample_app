module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end

  def remember_session(user)
    user.remember
    cookies.encrypted.permanent[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget_session(user)
    cookies.delete :user_id
    cookies.delete :remember_token
    user.forget unless user.nil?
  end

  def current_user
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      if user&.session_token == session[:session_token]
        user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated_with_token?(cookies[:remember_token])
        log_in(user)
        user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    reset_session
    forget_session(@current_user)
  end
end
