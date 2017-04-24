class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def update
    current_user.update_attribute(:bio, params[:user][:bio])
    redirect_to current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully edited!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.update_attribute(:bio, "#{@user.name} hasn't made a bio yet!")
      log_in @user
      remember @user
      flash[:success] = "Welcome to #{ Rails.application.config.TITLE }!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Sign up or log in before continuing"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def get_first_name
    name.split[0]
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation, :bio)
    end
end
