module Qe
  module Locale
    def self.included(base)
      unless base.included_modules.include?(Qe::Worker)
        raise OutOfOrderError, "must be included after Qe::Worker"
      end

      class << base
        # Intercept <tt>Worker.enqueue</tt> method, adding
        # the current locale to the options.
        enqueue = instance_method(:enqueue)
        define_method :enqueue do |options = {}|
          options[:locale] ||= I18n.locale
          enqueue.bind(self).call(options)
        end
      end

      base.class_eval do
        # Intercept <tt>Worker#before</tt> method and
        # set the current locale.
        before = instance_method(:before)
        define_method :before do
          I18n.locale = options.delete(:locale)
          before.bind(self).call
        end
      end
    end
  end
end
