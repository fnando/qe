require "qe"
require "sidekiq"

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

    def self.schedule(worker, run_at, options = {})
      Worker.sidekiq_options :queue => worker.queue
      Worker.perform_at(run_at, worker.name, options)
    end
  end

  self.adapter = Sidekiq
end
