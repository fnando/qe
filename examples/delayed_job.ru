require "bundler"
Bundler.setup(:default, :delayed_job)
Bundler.require(:default, :delayed_job)

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3", :database => "jobs.sqlite3"
)

require "delayed_job_web"
run DelayedJobWeb
