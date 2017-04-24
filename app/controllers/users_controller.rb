class UsersController < ApplicationController

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

  def create

    @user = User.new(user_params)
    if @user.save
      @user.update_attribute(:bio, "#{@user.name} hasn't made a bio yet!")
      log_in @user
      flash[:success] = "Welcome to #{ Rails.application.config.TITLE }!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation, :bio)
    end
end
