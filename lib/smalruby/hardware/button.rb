# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # ボタンを表現するクラス
    class Button < Dino::Components::Button
      def initialize(options)
        super(board: world.board, pin: Pin.smalruby_to_dino(options[:pin]))
      end

      def up?
        @state == UP
      end

      alias_method :on?, :up?

      def down?
        @state == DOWN
      end

      alias_method :off?, :down?

      private

      def after_initialize(options = {})
        super(options)

        s_pin = Pin.dino_to_smalruby(pin)
        down { world.button_changed(s_pin, :down) }
        up { world.button_changed(s_pin, :up) }
      end
    end
  end
end
