module Qe
  module ActionMailer
    MissingMailNameError = Class.new(StandardError)
    AbstractMethodError = Class.new(StandardError)

    def mail
      raise MissingMailNameError,
        "the :mail option is not defined" unless options[:mail]

      mailer.public_send(options[:mail], options)
    end

    def mailer
      raise AbstractMethodError,
        "you must implement the mailer method"
    end

    def perform
      mail.deliver
    end
  end
end
