# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # モータードライバを表現するクラス
    #
    # モータードライバのVrefにはPWM出力できるD3, D5, D6, D9, D10, D11の
    # いずれかを接続し、Vin1、Vin2はVrefからの連番(例えば、VrefがD3であ
    # ればVin1、Vin2はそれぞれD4, D5)を接続してください。
    #
    # 動作確認済みのモータードライバの一覧
    # * TOSHIBA
    #   * TA7291P
    class MotorDriver < Smalrubot::Components::BaseComponent
      # モーターの回転速度の割合(0～100%)
      attr_reader :speed

      def initialize(options)
        pin = Pin.smalruby_to_smalrubot(options[:pin])
        case pin
        when 3, 5, 6, 9, 10, 11
          super(board: world.board, pin: (pin...(pin + 3)).to_a)
        else
          fail "モーターのピン番号が間違っています: {options[:pin]}"
        end
        self.speed = options[:speed] || 100
      end

      def speed=(val)
        @speed = val
        if @speed < 0
          @speed = 0
        elsif @speed > 100
          @speed = 100
        end
      end

      # 正転する
      def forward
        write_pins(speed, 100, 0)
      end

      # 逆転する
      def backward
        write_pins(speed, 0, 100)
      end

      # 停止する
      def stop
        write_pins(0, 0, 0)
      end

      private

      def after_initialize(_ = {})
        pins.each do |pin|
          set_pin_mode(pin, :out)
        end
        stop
      end

      def write_pins(*levels)
        levels.each.with_index do |level, i|
          case level
          when 0
            digital_write(pins[i], Smalrubot::Board::LOW)
          when 100
            digital_write(pins[i], Smalrubot::Board::HIGH)
          else
            analog_write(pins[i], (Smalrubot::Board::HIGH * level / 100.0).round)
          end
        end
      end
    end
  end
end
