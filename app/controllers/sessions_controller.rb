class SessionsController < ApplicationController
  skip_before_action :login?
  REMEBER_ME = {on: '1', off: '0'}.freeze
  def new
  end

  def create
    logger = Logger.new("#{Rails.root}/log/login.log")
    logger.info "Params: #{params[:session]}"
    user = User.find_by(email: params[:session][:email])
    logger.info "User: #{user.inspect}"
    if user.try(:authenticate, params[:session][:password])
      logger.info "User: login true"
      logger.info "activated: #{user.activated}"
      if user.activated
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        generate_api_token(user)
        redirect_to users_path
      else
        message = "Account not activated. Check your email for the activation link."
        flash[:warning] = message
        redirect_to login_url
      end
    else
      flash.now[:danger] = t "invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    reset_api_token
    @current_user = nil
    redirect_to login_path
  end

  private

  def remember_me?
    params[:session][:remember_me] == REMEBER_ME[:on]
  end
end
