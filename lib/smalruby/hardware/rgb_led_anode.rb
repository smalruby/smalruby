# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # RGB LED(アノード)を表現するクラス
    class RgbLedAnode < Smalrubot::Components::BaseComponent
      def initialize(options)
        pin = Pin.smalruby_to_smalrubot(options[:pin])
        case pin
        when 3..6
          super(board: world.board, pin: [3, 5, 6, 4])
        when 9..12
          super(board: world.board, pin: [9, 10, 11, 12])
        else
          fail "RGB LED(anode)のピン番号が間違っています: {options[:pin]}"
        end
      end

      # RGB LEDを指定した色に光らせる
      def color=(val)
        color = Color.smalruby_to_dxruby(val)
        analog_write(pins[0], calc_value(color[0]))
        analog_write(pins[1], calc_value(color[1]))
        analog_write(pins[2], calc_value(color[2]))
        digital_write(pins[3], Smalrubot::Board::HIGH)
      end

      # RGB LEDをオフにする
      def turn_off
        digital_write(pins[3], Smalrubot::Board::LOW)
      end

      def stop
        turn_off
      end

      private

      def after_initialize(_ = {})
        set_pin_mode(pins[3], :out)
        turn_off
      end

      def calc_value(value)
        v = Smalrubot::Board::HIGH - value
        if v < Smalrubot::Board::LOW
          Smalrubot::Board::LOW
        elsif v > Smalrubot::Board::HIGH
          Smalrubot::Board::HIGH
        else
          v
        end
      end
    end
  end
end
