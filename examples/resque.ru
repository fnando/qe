require "bundler"
Bundler.setup(:default)
Bundler.require(:default)

require "resque/server"
run Resque::Server
