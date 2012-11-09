module Qe
  class Sidekiq
    class Worker
      include ::Sidekiq::Worker

      def perform(*args)
        Qe::Worker.perform(*args)
      end
    end

    def self.enqueue(worker, options = {})
      Worker.sidekiq_options :queue => worker.queue
      Worker.perform_async(worker.name, options)
    end
  end
end
