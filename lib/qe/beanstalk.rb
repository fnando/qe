require "qe"
require "backburner"

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

    def self.schedule(worker, run_at, options = {})
      delay = run_at - Time.now
      Worker.queue worker.queue
      Backburner::Worker.enqueue Worker, [worker.name, options], :delay => delay
    end
  end

  self.adapter = Beanstalk
end
