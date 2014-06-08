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
      def forward(left_level = Dino::Board::HIGH,
                  right_level = Dino::Board::HIGH)
        digital_write_pins(left_level, Dino::Board::LOW,
                           right_level, Dino::Board::LOW)
      end

      # 後退する
      def backward(left_level = Dino::Board::HIGH,
                   right_level = Dino::Board::HIGH)
        digital_write_pins(Dino::Board::LOW, left_level,
                           Dino::Board::LOW, right_level)
      end

      # 左に曲がる
      def turn_left(left_level = Dino::Board::HIGH,
                    right_level = Dino::Board::HIGH)
        digital_write_pins(Dino::Board::LOW, left_level,
                           right_level, Dino::Board::LOW)
      end

      # 右に曲がる
      def turn_right(left_level = Dino::Board::HIGH,
                     right_level = Dino::Board::HIGH)
        digital_write_pins(left_level, Dino::Board::LOW,
                           Dino::Board::LOW, right_level)
      end

      # 停止する
      def stop(left_level = Dino::Board::HIGH,
               right_level = Dino::Board::HIGH)
        digital_write_pins(Dino::Board::LOW, Dino::Board::LOW,
                           Dino::Board::LOW, Dino::Board::LOW)
      end

      # 命令する
      def run(options = {})
        defaults = {
          command: 'forward',
          sec: nil,
          left_level: 100,
          right_level: 100,
        }
        opts = Util.process_options(options, defaults)

        send(opts[:command], opts[:left_level], opts[:right_level])
        sleep(opts[:sec]) if opts[:sec]
        stop unless opts[:command] == :stop
      end

      private

      def after_initialize(_ = {})
        pins.each do |pin|
          set_pin_mode(pin, :out)
        end
        stop
      end

      def digital_write_pins(*levels)
        levels.each.with_index do
          |level, i|
          analog_write(pins[i], (Dino::Board::HIGH * level / 100.0).to_i)
          sleep(0.05) if i % 2 == 0
        end
      end
    end
  end
end
