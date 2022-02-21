module SessionsHelper
  def log_in(user)
    reset_session
    remember_session(user)
    session[:user_id] = user.id
  end

  def remember_session(user)
    user.remember
    cookies.encrypted.permanent[:user_id] = user.id
    cookies[:remember_token] = { value: user.remember_token,
                                 expires: 20.years.from_now.utc }
  end

  def forget_session(user)
    cookies.delete :user_id
    cookies.delete :remember_token
    user.forget unless user.nil?
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.encrypted[:user_id])
      user ||= User.find_by(id: user_id)
      if user&.authenticated_with_token?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    reset_session
    forget_session(@current_user)
    @current_user = nil
  end
end
