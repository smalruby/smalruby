# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # RGB LED(カソード)を表現するクラス
    class RgbLedCathode < Dino::Components::BaseComponent
      def initialize(options)
        pin = Pin.smalruby_to_dino(options[:pin])
        case pin
        when 3, 5, 6
          super(board: world.board, pin: [3, 5, 6])
        when 9..11
          super(board: world.board, pin: [9, 10, 11])
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
      end

      # RGB LEDをオフにする
      def off
        color = Color.smalruby_to_dxruby('black')
        analog_write(pins[0], calc_value(color[0]))
        analog_write(pins[1], calc_value(color[1]))
        analog_write(pins[2], calc_value(color[2]))
      end

      def stop
        off
      end

      private

      def after_initialize(_ = {})
        off
      end

      def calc_value(value)
        if value < Dino::Board::LOW
          Dino::Board::LOW
        elsif value > Dino::Board::HIGH
          Dino::Board::HIGH
        else
          value
        end
      end
    end
  end
end
