class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login?
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def login?
    return if logged_in?
    return render json: ResponseTemplate.unauthorized(t('user.login'))
  end
end
