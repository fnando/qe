require "qe"
require "resque"
require "resque_scheduler"

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

    def self.schedule(worker, run_at, options = {})
      Worker.instance_variable_set "@queue", worker.queue

      ::Resque.enqueue_at(run_at, Worker, worker.name, options)
    end
  end

  self.adapter = Resque
end
