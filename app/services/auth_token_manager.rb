require "redis_connector"

class AuthTokenManager
  def self.locate_user(token)
    RedisConnector.instance.redis.with do |conn|
      username = conn.get("Auth:#{token}")
      username.blank? ? nil : User.find(username)
    end
  end

  def self.generate_token(user)
    RedisConnector.instance.redis.with do |conn|
      token = SecureRandom.uuid
      conn.set("Auth:#{token}", user.username)
      conn.expire("Auth:#{token}", 3600 * 2) # token expires after 2 hours
      token
    end
  end
end
