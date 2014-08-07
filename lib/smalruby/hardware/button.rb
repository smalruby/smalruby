# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # ボタンを表現するクラス
    class Button < Dino::Components::Button
      def initialize(options)
        @using_pullup = true
        super(board: world.board, pin: Pin.smalruby_to_dino(options[:pin]),
              pullup: true)
      end

      # プルアップ抵抗を使わない
      def not_use_pullup
        @using_pullup = false
        board.set_pullup(pin, false)
      end

      def stop
        @board.remove_digital_hardware(self)
      end

      def up?
        @using_pullup ? @state == DOWN : @state == UP
      end

      alias_method :on?, :up?

      def down?
        !up?
      end

      alias_method :off?, :down?

      private

      def after_initialize(options = {})
        super(options)

        s_pin = Pin.dino_to_smalruby(pin)
        down { world.button_changed(s_pin, (@using_pullup ? :up : :down)) }
        up { world.button_changed(s_pin, (@using_pullup ? :down : :up)) }
      end
    end
  end
end
