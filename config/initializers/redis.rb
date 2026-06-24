default_redis_db = Rails.env.test? ? 15 : 1

REDIS = Redis.new(
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/#{default_redis_db}")
)
