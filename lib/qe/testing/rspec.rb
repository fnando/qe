require "qe/testing"

module Qe
  module EnqueueMatcher
    class Matcher
      attr_reader :worker, :options

      def initialize(worker)
        @worker = worker
      end

      def with(options)
        @options = options
        self
      end

      def matches?(block)
        block.call

        Qe.jobs.find do |job|
          condition = job[:worker] == worker
          condition = condition && job[:options] == options if options
          condition
        end != nil
      end

      def description
        "enqueue job for #{worker.inspect} worker"
      end

      def failure_message_for_should
        build_message "expect #{worker.inspect} to be enqueued"
      end

      def failure_message_for_should_not
        build_message "expect #{worker.inspect} not to be enqueued"
      end

      def build_message(base)
        base << (options.empty? ? "" : " with #{options.inspect}")
      end
    end

    #
    #   expect {}.to enqueue(MailerWorker).with(options)
    #
    def enqueue(worker)
      Matcher.new(worker)
    end
  end
end

RSpec.configure do |config|
  config.include Qe::EnqueueMatcher
  config.before(:each) do
    Qe.adapter = Qe::Testing
    Qe.jobs.clear
  end
end
