require "qe"
require "qu"

module Qe
  class Qu
    class Worker
      def self.perform(*args)
        Qe::Worker.perform(*args)
      end
    end

    def self.enqueue(worker, options = {})
      Worker.instance_variable_set("@queue", worker.queue)
      ::Qu.enqueue Worker, worker.name, options
    end

    def self.schedule(*)
      raise UnsupportedFeatureError, "scheduling isn't supported on Qu"
    end
  end

  self.adapter = Qu
end
