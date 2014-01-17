module Qe
  module Worker
    module InstanceMethods
      def initialize(options)
        @options = HashWithIndifferentAccess.new(options)
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
  end
end
