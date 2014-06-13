require "qe/testing"

module Qe
  module EnqueueMatcher
    class Matcher
      attr_reader :worker, :options, :date, :scheduled

      def initialize(worker, scheduled)
        @worker = worker
        @options = nil
        @scheduled = scheduled
      end

      def supports_block_expectations?
        true
      end

      def with(options = nil, &block)
        @options = block || options
        self
      end

      def on(date)
        @date = date
        self
      end

      def matches?(block)
        block.call
        @options = @options.call if @options.respond_to?(:call)

        result = jobs.any? do |job|
          condition = job[:worker] == worker
          condition = condition && datetime? if scheduled
          condition = condition && job[:options] == (options.kind_of?(Proc) ? options.call : options) if options
          condition = condition && job[:run_at].to_i == date.to_i if date
          condition
        end

        !!result
      end

      def does_not_match?(block)
        block.call

        jobs.none? do |job|
          condition = job[:worker] != worker
          condition = condition && job[:options] != (options.kind_of?(Proc) ? options.call : options) if options
          condition = condition && job[:run_at].to_i != date.to_i if date
          condition
        end
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
        base << ((options || {}).empty? ? "" : " with #{options.inspect}")
        base << " on #{date.inspect}" if date
        base
      end

      def jobs
        Qe.jobs.select do |job|
          scheduled ? job.key?(:run_at) : true
        end
      end

      def datetime?
        [Date, Time, DateTime].find {|klass| date.kind_of?(klass) }
      end
    end

    #
    #   expect {}.to enqueue(MailerWorker).with(options)
    #
    def enqueue(worker)
      Matcher.new(worker, false)
    end

    #
    #   expect {}.to schedule(MailerWorker).on(Time.now).with(options)
    #
    def schedule(worker)
      Matcher.new(worker, true)
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
