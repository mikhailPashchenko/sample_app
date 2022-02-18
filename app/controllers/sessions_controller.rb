class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      reset_session
      log_in(user)
      flash[:success] = 'You are logged in!'
      return redirect_to user
    elsif user.nil?
      flash.now[:danger] = 'Email not found!'
    else
      flash.now[:danger] = 'Incorrect password!'
    end
    render :new
  end
end
