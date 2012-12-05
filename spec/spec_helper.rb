require "bundler"
Bundler.setup(:default, :development)
Bundler.require(:default, :development)

require "qe"
require "qe/testing/rspec"
require "qe/beanstalk"
require "qe/resque"
require "qe/sidekiq"
require "qe/qu"
require "qe/delayed_job"
require "delayed_job_active_record"

require "support/hello_worker"
require "support/localized_worker"
