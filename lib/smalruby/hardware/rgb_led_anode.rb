# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # RGB LED(アノード)を表現するクラス
    class RgbLedAnode < Dino::Components::BaseComponent
      def initialize(options)
        pin = Pin.smalruby_to_dino(options[:pin])
        case pin
        when 3..6
          super(board: world.board, pin: [3, 5, 6, 4])
        when 9..12
          super(board: world.board, pin: [9, 10, 11, 12])
        else
          fail "RGB LED(anode)のピン番号が間違っています: {options[:pin]}"
        end
      end

      # RGB LEDをオンにする
      def on(options = {})
        defaults = {
          color: 'white'
        }
        opts = Util.process_options(options, defaults)

        color = Color.smalruby_to_dxruby(opts[:color])
        analog_write(pins[0], calc_value(color[0]))
        analog_write(pins[1], calc_value(color[1]))
        analog_write(pins[2], calc_value(color[2]))
        digital_write(pins[3], Dino::Board::HIGH)
      end

      # RGB LEDをオフにする
      def off
        digital_write(pins[3], Dino::Board::LOW)
      end

      def stop
        off
      end

      private

      def after_initialize(_ = {})
        set_pin_mode(pins[3], :out)
        off
      end

      def calc_value(value)
        v = Dino::Board::HIGH - value
        if v < Dino::Board::LOW
          Dino::Board::LOW
        elsif v > Dino::Board::HIGH
          Dino::Board::HIGH
        else
          v
        end
      end
    end
  end
end
