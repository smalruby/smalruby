# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # ボタンを表現するクラス
    class Button < Smalrubot::Components::BaseComponent
      def initialize(options)
        super(board: world.board, pin: Pin.smalruby_to_smalrubot(options[:pin]),
              pullup: false)
      end

      def released?
        board.digital_read(pin) == 0
      end

      alias_method :off?, :released?
      alias_method :up?, :released?

      def pressed?
        !released?
      end

      alias_method :on?, :pressed?
      alias_method :down?, :pressed?

      private

      def after_initialize(_ = {})
        set_pin_mode(:in)
      end
    end
  end
end
