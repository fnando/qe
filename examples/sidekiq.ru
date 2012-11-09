require "bundler"
Bundler.setup(:default)
Bundler.require(:default)

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require "sidekiq/web"
run Sidekiq::Web
