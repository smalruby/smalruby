module Smalruby
  module Arduino
    class Led < Dino::Components::Led
      def analog_on(num)
        analog_write(num)
      end
    end
  end
end