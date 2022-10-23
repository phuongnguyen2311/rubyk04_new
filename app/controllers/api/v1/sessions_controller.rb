class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :verify_token
  REMEBER_ME = {on: '1', off: '0'}.freeze

  def create
    user = User.find_by(email: params[:email])
    if user.try(:authenticate, params[:password])
      if user.activated
        log_in user
        params[:remember_me] == "1" ? remember(user) : forget(user)
        generate_api_token(user)
        render json: success_message('Successfully', serializer(user, UserSerializer))
      else
        message = "Account not activated. Check your email for the activation link."
        render json: error_message(message)
      end
    else
      render json: error_message(t "invalid_email_password_combination")
    end
  end

  def destroy
    session.delete(:user_id)
    reset_api_token
    @current_user = nil
    render json: success_message('Sign out sucessfully')
  end

  private

  def remember_me?
    params[:session][:remember_me] == REMEBER_ME[:on]
  end
end
