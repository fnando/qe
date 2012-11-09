module Qe
  class Immediate
    def self.enqueue(worker, options = {})
      Qe::Worker.perform(worker.name, options)
    end
  end
end
