Sidekiq.configure_server do |config|
  config.redis = { url: APP_ENV["REDIS_URL"] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: APP_ENV["REDIS_URL"] }
end
