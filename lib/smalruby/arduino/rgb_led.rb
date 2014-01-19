module Smalruby
  module Arduino
    class Rgb_led < BaseComponent
      # options = {board: my_board, pins: {red: red_pin, green: green_pin, blue: blue_pin}
      def after_initialize(options={})
        raise 'missing pins[:red] pin' unless self.pins[:red]
        raise 'missing pins[:green] pin' unless self.pins[:green]
        raise 'missing pins[:blue] pin' unless self.pins[:blue]

        pins.each do |color, pin|
          set_pin_mode(pin, :out)
          analog_write(pin, Board::LOW)
        end

        self.off
      end

      # Format: [R, G, B]
      COLORS = {
        red:     [000, 255, 255],
        green:   [255, 000, 255],
        blue:    [255, 255, 000],
        cyan:    [255, 000, 000],
        yellow:  [000, 000, 255],
        magenta: [000, 255, 000],
        white:   [000, 000, 000],
        off:     [255, 255, 255]
      }

      COLORS.each_key do |color|
        define_method(color) do
          analog_write(pins[:red], COLORS[color][0])
          analog_write(pins[:green], COLORS[color][1])
          analog_write(pins[:blue], COLORS[color][2])
        end 
      end
    end
  end
end