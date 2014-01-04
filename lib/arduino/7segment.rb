module Smalruby
  module Arduino
    class SevenSegment < Dino::Components::BaseComponent
      # options = {board: my_board, pins: [pin1, pin2, ...]
      def after_initialize(options=[])
        raise 'missing pins[0] pin' unless self.pins[0]
        raise 'missing pins[1] pin' unless self.pins[1]
        raise 'missing pins[2] pin' unless self.pins[2]
        raise 'missing pins[3] pin' unless self.pins[3]
        raise 'missing pins[4] pin' unless self.pins[4]
        raise 'missing pins[5] pin' unless self.pins[5]
        raise 'missing pins[6] pin' unless self.pins[6]
        raise 'missing pins[7] pin' unless self.pins[7]

        pins.each do |pin|
          set_pin_mode(pin, :out)
          analog_write(pin, Board::LOW)
        end

        self.off
      end

      NUMBERS = {
        zero:  [1, 3, 4, 5, 6, 7],
        one:   [4, 7],
        two:   [0, 3, 4, 5, 6],
        three: [0, 3, 4, 6, 7],
        four:  [0, 1, 4, 7],
        five:  [0, 1, 3, 6, 7],
        six:   [0, 1, 3, 5, 6, 7],
        seven: [1, 3, 4, 7],
        eight: [0, 1, 3, 4, 5, 6, 7],
        nine:  [0, 1, 3, 4, 6, 7],
        off:   []
      }


      NUMBERS.each do |number, pins_light|
        define_method(number) do
          8.times do |i|
            if pins_light.include?(i)
              digital_write(pins[i], Board::LOW)
            else
              digital_write(pins[i], Board::HIGH)
            end
          end
        end
      end
    end
  end
end