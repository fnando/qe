require "qe"
require "delayed_job"

module Qe
  class DelayedJob
    class Worker < Struct.new(:worker_name, :options)
      def perform
        Qe::Worker.perform(worker_name, options)
      end
    end

    def self.enqueue(worker, options = {})
      Delayed::Job.enqueue Worker.new(worker.name, options),
        :queue => worker.queue
    end

    def self.schedule(worker, run_at, options = {})
      Delayed::Job.enqueue Worker.new(worker.name, options),
        :queue => worker.queue,
        :run_at => run_at
    end
  end

  self.adapter = DelayedJob
end
