# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # 2WD車のモーターを表現するクラス
    class TwoWheelDriveCar < Dino::Components::BaseComponent
      # 左のモーターの速度%
      attr_reader :left_speed

      # 右のモーターの速度%
      attr_reader :right_speed

      def initialize(options)
        @left_speed = 100
        @right_speed = 100

        pin = Pin.smalruby_to_dino(options[:pin])
        case pin
        when 5
          super(board: world.board, pin: [5, 6, 9, 10])
        when 6
          super(board: world.board, pin: (pin...(pin + 4)).to_a)
        else
          fail "モーターのピン番号が間違っています: {options[:pin]}"
        end
      end

      [:left, :right].each do |lor|
        define_method("#{lor}_speed=") do |val|
          name = "@#{lor}_speed"
          if val < 0
            instance_variable_set(name, 0)
          elsif val > 100
            instance_variable_set(name, 100)
          else
            instance_variable_set(name, val)
          end
        end
      end

      # 前進する
      def forward
        digital_write_pins(left_speed, 0, right_speed, 0)
      end

      # 後退する
      def backward
        digital_write_pins(0, left_speed, 0, right_speed)
      end

      # 左に曲がる
      def turn_left
        digital_write_pins(0, left_speed, right_speed, 0)
      end

      # 右に曲がる
      def turn_right
        digital_write_pins(left_speed, 0, 0, right_speed)
      end

      # 停止する
      def stop
        digital_write_pins(0, 0, 0, 0)
      end

      # 命令する
      def run(options = {})
        defaults = {
          command: 'forward',
          sec: nil,
        }
        opts = Util.process_options(options, defaults)

        send(opts[:command])
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

      def digital_write_pins(*speeds)
        if pins.first == 5
          speeds.each.with_index do |speed, i|
            level = (Dino::Board::HIGH * speed / 100.0).floor
            case level
            when 0
              digital_write(pins[i], Dino::Board::LOW)
            when 100
              digital_write(pins[i], Dino::Board::HIGH)
            else
              analog_write(pins[i], level)
            end
          end
        else
          2.times do
            speeds.each.with_index do
              |speed, i|
              digital_write(pins[i], (Dino::Board::HIGH * speed / 100.0).floor)
              sleep(0.05) if i.odd?
            end
          end
        end
      end
    end
  end
end
