class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new;end

  def edit
    @user = User.find_by email: params[:email]
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to login_path
    else
      flash.now[:danger] = "Email address not found"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, 'can\'t blank')
      render :edit
    elsif @user.update(user_params)
      flash[:info] = "Please login with new password"
      redirect_to login_path
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated && @user&.authenticated?(:reset, params[:id])
    flash[:danger] = "Token invalid"
    redirect_to login_path
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = "Password reset has expired."
    redirect_to new_password_reset_url
  end
end
