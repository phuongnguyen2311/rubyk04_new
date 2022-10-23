class UserSerializer < BaseSerializer
  attributes :id, :name, :email, :api_token, :avatar

  def api_token
    object.api_token
  end

  def avatar
    gravatar_id = Digest::MD5::hexdigest object.email.downcase
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=40"
  end
end
