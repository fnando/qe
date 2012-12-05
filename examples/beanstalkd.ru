require "bundler"
Bundler.setup(:default, :beanstalk)
Bundler.require(:default, :beanstalk)

run BeanstalkdView::Server
