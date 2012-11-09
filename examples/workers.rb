require "bundler"
Bundler.setup(:default)
Bundler.require

$:.unshift File.expand_path("../../lib", __FILE__)
require "qe"

$stdout.sync = true

Qe.adapter = Qe::Sidekiq
# Qe.adapter = Qe::Beanstalk
# Qe.adapter = Qe::Resque
# Qe.adapter = Qe::DelayedJob
# Qe.adapter = Qe::Qu
# Qe.adapter = Qe::Testing

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "jobs.sqlite3")

class ClockWorker
  include Qe::Worker

  def perform
    puts "=> Time: #{Time.now}"
  end
end

class MailerWorker
  include Qe::Worker
  queue :mail

  def before
    puts "=> Running before"
  end

  def perform
    puts "=> Performing"
    puts "=> Options: #{options.inspect}"
  end

  def after
    puts "=> Running after"
  end
end
