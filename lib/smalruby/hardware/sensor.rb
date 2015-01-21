# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # 汎用的なセンサーを表現するクラス
    class Sensor < Smalrubot::Components::BaseComponent
      def initialize(options)
        super(board: world.board, pin: Pin.smalruby_to_smalrubot(options[:pin]))
      end

      def value
        board.analog_read(pin)
      end
    end
  end
end
