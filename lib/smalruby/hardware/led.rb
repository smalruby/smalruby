# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # LEDを表現するクラス
    class Led < Smalrubot::Components::Led
      def initialize(options)
        super(board: world.board, pin: Pin.smalruby_to_smalrubot(options[:pin]))
      end

      # @!method turn_on
      # LEDをオンにする
      alias_method :turn_on, :on

      # @!method turn_off
      # LEDをオフにする
      alias_method :turn_off, :off

      def stop
        turn_off
      end
    end
  end
end
