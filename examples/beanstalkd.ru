require "bundler"
Bundler.setup(:default)
Bundler.require(:default)

run BeanstalkdView::Server
