require "bundler/setup"
Bundler.require(:default, ENV.fetch("GROUP"))

require "time"

$:.unshift File.expand_path("../../lib", __FILE__)

case ENV.fetch("GROUP")
when "sidekiq"
  require "qe/sidekiq"
when "beanstalk"
  require "qe/beanstalk"
  require "backburner/tasks"

  Backburner.configure do |config|
    config.logger = Logger.new($stdout)
  end
when "resque"
  require "qe/resque"
  require "resque/tasks"
  require "resque_scheduler/tasks"
when "delayed_job"
  require "delayed_job"
  require "delayed_job_active_record"
  require "qe/delayed_job"
  require "active_record"
  require "delayed/tasks"
when "qu"
  require "qe/qu"
  require "qu/tasks"
end

$stdout.sync = true

if defined?(Qe::DelayedJob)
  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3", :database => "jobs.sqlite3"
  )
end

class ClockWorker
  include Qe::Worker

  def perform
    puts
    puts "---"
    puts "=> Time: #{Time.now}"
    puts "---"
    puts
  end
end

class MailerWorker
  include Qe::Worker
  queue :mail

  def before
    puts
    puts "---"
    puts "=> Running before"
  end

  def perform
    puts "=> Performing"
    puts "=> Options: #{options.inspect}"
  end

  def after
    puts "=> Running after"
    puts "---"
    puts
  end
end

class LaterWorker
  include Qe::Worker

  def perform
    puts
    puts "---"
    puts "=> Job scheduled on #{options.inspect}"
    puts "=> But executed on #{Time.now}"
    puts "---"
    puts
  end
end
