class SessionsController < ApplicationController
  include SessionsHelper

  before_action :set_current_user
  protect_from_forgery with: :null_session

  def new
    if @current_user
      flash[:warning] = 'You are already logged in!'
      redirect_to @current_user
    end
  end

  def create
    if @current_user
      flash[:warning] = 'You are already logged in!'
      return redirect_to @current_user
    end

    @user = User.find_by(email: params[:session][:email])
    if @user&.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == '1' ? remember_session(@user) :
                                              forget_session(@user)
      log_in(@user)
      flash[:success] = 'You are logged in!'
      return redirect_to forwarding_url || @user
    elsif @user.nil?
      flash.now[:danger] = 'Email not found!'
    else
      flash.now[:danger] = 'Incorrect password!'
    end
    render :new
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, flash: { success: "You have successfully logged out." }
  end

  private
  def set_current_user
    @current_user = current_user
  end
end
