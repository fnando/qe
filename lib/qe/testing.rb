module Qe
  def self.jobs
    @jobs ||= []
  end

  class Testing
    def self.enqueue(worker, options = {})
      Qe.jobs << {:worker => worker, :options => options}
    end
  end
end
