class Api::V1::BaseController < ApplicationController
  skip_before_action :login?
  protect_from_forgery with: :null_session
  before_action :verify_token

protected
  def success_message(message, content={})
    ResponseTemplate.success(message, content)
  end

  def error_message(message, content={})
    ResponseTemplate.error(message, content)
  end

  def unauthorized_message(message, content={})
    ResponseTemplate.unauthorized(message, content)
  end

  def api_token?
    request.headers["Api-Token"].present?
  end

  def current_user
    token = request.headers["Api-Token"]
    @current_user ||= User.find_by(api_token_digest: token)
  end

  def verify_token
    return if api_token? && current_user
    render json: unauthorized_message('Unauthorized not valid')
  end

  def gravatar_for_user(user, options = {size: 40})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end