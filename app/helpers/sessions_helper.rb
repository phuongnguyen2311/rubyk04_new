module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def loggin?
    return if logged_in?
    flash[:danger] = 'Please login'
    redirect_to login_path
  end
end
