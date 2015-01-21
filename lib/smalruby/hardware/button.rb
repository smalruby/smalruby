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

      def up?
        board.digital_read(pin) == 0
      end

      alias_method :off?, :up?

      def down?
        !up?
      end

      alias_method :on?, :down?

      private

      def after_initialize(_ = {})
        set_pin_mode(:in)
      end
    end
  end
end
