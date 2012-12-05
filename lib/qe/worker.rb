module Qe
  module Worker
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    # Find a worker by its name.
    # If worker constant is not found, raises a +NameError+
    # exception.
    def self.find(name)
      name.split("::").reduce(Object) do |const, name|
        const.const_get(name)
      end
    end

    # Perform the specified worker if given options.
    def self.perform(worker_name, options)
      find(worker_name).new(options).tap do |job|
        begin
          job.before
          job.perform
          job.after
        rescue Exception => error
          job.error(error)
        end
      end
    end
  end
end
