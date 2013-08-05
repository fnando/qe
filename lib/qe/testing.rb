module Qe
  def self.jobs
    @jobs ||= []
  end

  def self.drain
    jobs.each do |job|
      Qe::Worker.perform(job[:worker].name, job[:options])
    end
  end

  class Testing
    def self.enqueue(worker, options = {})
      Qe.jobs << {worker: worker, options: options}
    end

    def self.schedule(worker, run_at, options = {})
      Qe.jobs << {worker: worker, options: options, run_at: run_at}
    end
  end
end
