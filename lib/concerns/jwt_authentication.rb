module JwtAuthentication
  HMAC = 'HS256'.freeze
  def self.encode(payload)
    JWT.encode payload, Settings.hmac_secret, HMAC
  rescue
    nil
  end

  def self.decode(token)
    JWT.decode token, Settings.hmac_secret, true, { algorithm: HMAC }
  rescue
    nil
  end
end