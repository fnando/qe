require "active_support/hash_with_indifferent_access"

require "qe/action"
require "qe/action_mailer"
require "qe/locale"
require "qe/immediate"
require "qe/version"
require "qe/worker/class_methods"
require "qe/worker/instance_methods"
require "qe/worker"

# In this wild world where a new asynchronous job processing
# library is released every once in a while, Qe tries to keep a unified
# interface that works with most famous libraries:
#
# # Sidekiq
# # Resque
# # DelayedJob
# # Qu
# # Beanstalk/Backburner
#
# See an example:
#
# You can choose an adapter:
#
#   Qe.adapter = Qe::Sidekiq
#   Qe.adapter = Qe::Resque
#   Qe.adapter = Qe::Qu
#   Qe.adapter = Qe::DelayedJob
#   Qe.adapter = Qe::Beanstalk
#
# Create our worker that will send e-mails through +ActionMailer+.
#
#   class MailerWorker
#     include Qe::Worker
#
#     def perform
#       Mailer.public_send(options[:mail], options).deliver
#     end
#   end
#
# Define our +Mailer+ class.
#
#   class Mailer < ActionMailer::Base
#     def welcome(options)
#       @options = options
#       mail :to => options[:email]
#     end
#   end
#
# Enqueue a job to be processed asynchronously.
#
#   MailerWorker.enqueue({
#     :mail => :welcome,
#     :email => "john@example.org",
#     :name => "John Doe"
#   })
#
# You can specify when this job must be processed by setting the <tt>:run_at</tt>
# option.
#
#   MailerWorker.enqueue({
#     :mail => :follow_up,
#     :email => "john@example.org",
#     :name => "John Doe",
#     :run_at => 5.days.from_now
#   })
#
# == Testing support
#
# Qe comes with testing support. Just require the <tt>qe/testing.rb</tt> file
# and a fake queuing adapter will be used. All enqueued jobs will be stored
# at <tt>Qe.jobs</tt>. Note that this method is only available on testing mode.
#
#   require "qe/testing"
#   Qe.adapter = Qe::Testing
#
# If you're using RSpec, you can require the <tt>qe/testing/rspec.rb</tt> file
# instead. This will reset <tt>Qe.jobs</tt> before every spec and will add a
# +enqueue+ matcher.
#
#   require "qe/testing/rspec"
#
#   describe "Enqueuing a job" do
#     it "enqueues job" do
#       expect {
#         # do something
#       }.to enqueue(MailerWorker).with(:email => "john@example.org")
#     end
#   end
#
module Qe
  class << self
    attr_accessor :adapter
  end

  # Error that is raised when trying to use a feature
  # that isn't supported by some adapter.
  UnsupportedFeatureError = Class.new(StandardError)

  # Error that is raised when trying to include a
  # module before Qe::Worker is included.
  OutOfOrderError = Class.new(StandardError)
end
