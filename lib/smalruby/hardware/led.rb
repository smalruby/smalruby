# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # LEDを表現するクラス
    class Led < Dino::Components::Led
      def initialize(options)
        super(board: world.board, pin: Pin.smalruby_to_dino(options[:pin]))
      end

      # @!method on
      # LEDをオンにする

      # @!method off
      # LEDをオフにする

      def stop
        off
      end
    end
  end
end
