module Qe
  class Qu
    class Worker
      include ::Sidekiq::Worker

      def self.perform(*args)
        Qe::Worker.perform(*args)
      end
    end

    def self.enqueue(worker, options = {})
      Worker.instance_variable_set("@queue", worker.queue)
      ::Qu.enqueue Worker, worker.name, options
    end
  end
end
