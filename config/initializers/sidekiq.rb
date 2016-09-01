require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [ENV['SIDEKIQ_ADMIN_USERNAME'], ENV['SIDEKIQ_ADMIN_PASSWORD']]
end

Sidekiq.configure_server do |config|
  config.redis = {url: $redis.client.options[:url]}
end

