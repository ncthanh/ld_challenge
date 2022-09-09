require "singleton"

class RedisConnector
  include Singleton
  attr_reader :redis

  def initialize
    @redis = ConnectionPool.new(size: Integer(ENV["REDIS_POOL"] || 4), timeout: 20) do
      Redis.new(
        host: ENV["REDIS_HOST"] || "localhost",
        port: ENV["REDIS_PORT"] || "6379",
        ssl: (ENV["REDIS_SSL_ENABLED"] || "false") == "true",
      )
    end
  end
end
