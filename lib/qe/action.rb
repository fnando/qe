module Qe
  module Action
    MissingActionError = Class.new(StandardError)

    def perform
      action = options.fetch(:action, :default)

      raise MissingActionError,
        "the action #{action.inspect} is not defined" unless respond_to?(action)

      public_send(action)
    end
  end
end
