module Qe
  class Resque
    class Worker
      def self.perform(*args)
        Qe::Worker.perform(*args)
      end
    end

    def self.enqueue(worker, options = {})
      Worker.instance_variable_set "@queue", worker.queue
      ::Resque.enqueue Worker, worker.name, options
    end
  end
end
