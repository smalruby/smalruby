# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # 汎用的なセンサーを表現するクラス
    class Sensor < Dino::Components::Sensor
      # デフォルトのセンサーの値に変化があったかどうかをチェックする閾値
      DEFAULT_THRESHOLD = 32

      attr_reader :value
      attr_accessor :threshold

      def initialize(options)
        super(board: world.board, pin: Pin.smalruby_to_dino(options[:pin]))
      end

      def stop
        @board.remove_analog_hardware(self)
      end

      private

      def after_initialize(options = {})
        super(options)

        @value = 0
        @threshold = options[:threshold] || DEFAULT_THRESHOLD

        start_receiving_data
      end

      def start_receiving_data
        prev_data = 0
        when_data_received { |data|
          begin
            @value = data = data.to_i
            if (data - prev_data).abs >= @threshold ||
                (prev_data != data && (data == 0 || data >= 1023))
              world.sensor_changed(pin, data)
              prev_data = data
            end
          rescue
            Util.print_exception($ERROR_INFO)
          end
        }
      end
    end
  end
end
