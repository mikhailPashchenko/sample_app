class UsersController < ApplicationController
  include SessionsHelper

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      flash[:danger] = "Try again!"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    #if user_logged_in?(@user)
    # => show personal page
    #else
    # => show public page
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
