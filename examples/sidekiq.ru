require "bundler"
Bundler.setup(:default, :sidekiq)
Bundler.require(:default, :sidekiq)

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require "sidekiq/web"
run Sidekiq::Web
