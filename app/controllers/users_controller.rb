class UsersController < ApplicationController
  include SessionsHelper

  before_action :find_user, except: [:new, :create]
  before_action :logged_in, only: [:index, :edit, :update, :destroy]
  before_action :check_activate, except: [:new, :create, :show, :activate]
  before_action :check_authorisation, only: [:edit, :update]
  before_action :check_admin, only: [:destroy]

  def index
    @user = current_user
    @users = User.paginate(page: params[:page]).order(:id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.active = false
    if @user.save
      reset_session
      # User::UserActivatorService.call(@user)
      @user.set_activation_token
      remember_session @user
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      flash[:danger] = "Try again!"
      render :new, status: :unprocessable_entity
    end
  end

  def show  
    return redirect_to current_user, flash: {
      warning: "Your account isn't activated yet"
    } if !current_user?(@user) && !current_user.active?

    redirect_to root_path, flash: { warning: 'User not found!' } if @user.nil?
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

  def activate
    if @user.active?
      flash[:notice] = "Your account is active already"
    elsif @user.activation_token != params[:token]
      flash[:danger] = "Incorrect activation link!"
    else
      @user.active = true
      if @user.save
        flash[:success] = "Your account was activated"
      else
        flash[:danger] = "Error! Please connect with administrator!"
      end
    end
    redirect_to @user
  end


  private
  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation, :active
    )
  end

  def find_user
    @user = User.unscoped.find_by(id: params[:id])
  end

  def check_activate
    redirect_to current_user, flash: {
      warning: "Your account isn't activated yet"
    } unless current_user&.active?
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
