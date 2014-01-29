# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # LEDを表現するクラス
    class Led < Dino::Components::Led
      def initialize(options)
        super(board: world.board, pin: options[:pin])
      end
    end

    # @!method on
    # LEDをオンにする

    # @!method off
    # LEDをオフにする
  end
end
