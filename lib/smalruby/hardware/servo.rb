# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # サーボモーターを表現するクラス
    class Servo < Dino::Components::Servo
      def initialize(options)
        super(board: world.board, pin: Pin.smalruby_to_dino(options[:pin]))
      end

      # @!method position=(angle)
      # サーボモーターを(  )度にする

      private

      # HACK: GROVEシステムのサーボモーターでは5よりも小さい値を指定す
      #   るとモーターが発振してしまう
      MIN_ANGLE = 5
      MAX_ANGLE = 180

      def angle(value)
        if value < MIN_ANGLE
          MIN_ANGLE
        elsif value > MAX_ANGLE
          MAX_ANGLE
        else
          value
        end
      end
    end
  end
end
