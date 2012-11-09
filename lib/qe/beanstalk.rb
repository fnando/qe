module Qe
  class Beanstalk
    class Worker
      include Backburner::Queue

      def self.perform(*args)
        Qe::Worker.perform(*args)
      end
    end

    def self.enqueue(worker, options = {})
      Worker.queue worker.queue
      Backburner.enqueue Worker, worker.name, options
    end
  end
end
