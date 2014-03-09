# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # 2WD車のモーターを表現するクラス
    class TwoWheelDriveCar < Dino::Components::BaseComponent
      def initialize(options)
        pin = Pin.smalruby_to_dino(options[:pin])
        case pin
        when 2..10
          super(board: world.board, pin: (pin...(pin + 4)).to_a)
        else
          fail "モーターのピン番号が間違っています: {options[:pin]}"
        end
      end

      # 前進する
      def forward
        digital_write_pins(true, false, true, false)
      end

      # 後退する
      def backward
        digital_write_pins(false, true, false, true)
      end

      # 左に曲がる
      def turn_left
        digital_write_pins(false, true, true, false)
      end

      # 右に曲がる
      def turn_right
        digital_write_pins(true, false, false, true)
      end

      # 停止する
      def stop
        digital_write_pins(false, false, false, false)
      end

      private

      def after_initialize(options = {})
        pins.each do |pin|
          set_pin_mode(pin, :out)
        end
        stop
      end

      def digital_write_pins(*level_flags)
        level_flags.each.with_index do |level_flag, i|
          level = level_flag ? Dino::Board::HIGH : Dino::Board::LOW
          digital_write(pins[i], level)
        end
      end
    end
  end
end
