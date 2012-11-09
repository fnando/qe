module Qe
  module Worker
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module InstanceMethods
      def initialize(options)
        @options = options
      end

      # Return options that were provided when
      # adding job to the queue.
      def options
        @options
      end

      # Set before hook.
      def before
      end

      # Set after hook.
      def after
      end

      # Set the error hook.
      def error(error)
        raise error
      end
    end

    module ClassMethods
      # Enqueue job on given worker class.
      def enqueue(options = {})
        Qe.adapter.enqueue(self, options)
      end

      # Set the queue name when receiving on argument.
      # Return queue name otherwise.
      def queue(*args)
        @queue = args.first unless args.empty?
        (@queue || :default).to_s
      end
    end

    # Find a worker by its name.
    # If worker constant is not found, raises a +NameError+
    # exception.
    def self.find(name)
      name.split("::").reduce(Object) do |const, name|
        const.const_get(name)
      end
    end

    # Perform the specified worker if given options.
    def self.perform(worker_name, options)
      find(worker_name).new(options).tap do |job|
        begin
          job.before
          job.perform
          job.after
        rescue Exception => error
          job.error(error)
        end
      end
    end
  end
end
