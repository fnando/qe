module Qe
  module Worker
    module ClassMethods
      # Enqueue job on given worker class.
      def enqueue(options = {})
        run_at = options.delete(:run_at)

        if run_at
          Qe.adapter.schedule(self, run_at, options)
        else
          Qe.adapter.enqueue(self, options)
        end
      end

      # Set the queue name when receiving one argument.
      # Return queue name otherwise.
      def queue(*args)
        @queue = args.first unless args.empty?
        (@queue || :default).to_s
      end
    end
  end
end
