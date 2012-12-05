require "bundler"
Bundler.setup(:default, :resque)
Bundler.require(:default, :resque)

require "resque/server"
run Resque::Server
