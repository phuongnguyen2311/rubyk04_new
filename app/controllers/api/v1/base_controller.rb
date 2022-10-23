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

  def errors(messages, content={})
    ResponseTemplate.errors(messages, content)
  end

  def unauthorized_message(message, content={})
    ResponseTemplate.unauthorized(message, content)
  end

  def api_token?
    request.headers["Api-Token"].present?
  end

  def current_user
    token = request.headers["Api-Token"]
    data = JwtAuthentication.decode(token).try(&:first)
    return nil unless data
    user = User.find_by(id: data['user_id'])
    return nil unless user&.authenticated?(:api_token, data['api_token'])
    @current_user ||= user
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

  def serializer(data, klass)
    ActiveModelSerializers::SerializableResource.new(data, each_serializer: klass)
  end
end