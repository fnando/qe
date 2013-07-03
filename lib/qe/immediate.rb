module Qe
  class Immediate
    def self.enqueue(worker, options = {})
      Qe::Worker.perform(worker.name, options)
    end

    def self.schedule(worker, run_at, options = {})
      enqueue(worker, options)
    end
  end
end
