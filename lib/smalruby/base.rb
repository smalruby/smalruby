require 'forwardable'

module Smalruby
  class Base
    extend Forwardable

    def on(event, *args, &block)
      case event
      when :start
        instance_eval(&block)
      end
    end
  end
end
