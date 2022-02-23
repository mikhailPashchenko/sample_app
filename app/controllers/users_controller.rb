class UsersController < ApplicationController
  include SessionsHelper

  before_action :find_user, except: [:new, :create]
  before_action :logged_in, only: [:index, :edit, :update]
  before_action :check_authorisation, only: [:edit, :update]
  before_action :check_admin, only: [:destroy]

  def index
    @user = current_user
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      remember_session @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      flash[:danger] = "Try again!"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    if @user.nil?
      redirect_to root_path, flash: { warning: 'User not found!' }
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user
      @user.destroy
      flash[:success] = "User was deleted"
      redirect_to users_path
    else
      flash.now[:danger] = "User not found"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(id: params[:id])
  end

  def logged_in
    unless logged_in?
      flash[:warning] = "Please log in to access this page"
      store_location
      redirect_to "#{login_path}?from=#{params[:action]}_user"#, params: { from: 'edit_user'}
    end
  end

  def check_authorisation
    unless current_user?(@user) || current_user.is_god?
      flash[:warning] = "You don't have permissions to this action"
      redirect_to current_user
    end
  end

  def check_admin
    unless current_user.is_god?
      flash[:warning] = "You don't have permissions to this action"
      redirect_to current_user
    end
  end
end
