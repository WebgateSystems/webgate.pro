Sidekiq.configure_server do |config|
  config.redis = { url: APP_CONFIG['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: APP_CONFIG['REDIS_URL'] }
end
