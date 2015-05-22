# -*- coding: utf-8 -*-
require 'smalruby/hardware'
require "set"

module Smalruby
  module Hardware
    # Adafruit NeoPixel RGB LED class
    class NeoPixel < Smalrubot::Components::BaseComponent
      include Util

      def initialize(options)
        pin = Pin.smalruby_to_smalrubot(options[:pin])
        case pin
        when 3, 5, 6, 9, 10, 11
          super(board: world.board, pin: pin)
        else
          fail "ピン番号が間違っています: {options[:pin]}"
        end
        @indexes = Set.new
      end

      # set color
      def set(options)
        defaults = {
          index: 0,
          color: "black",
          show: true,
        }
        opts = process_options(options, defaults)
        @indexes << opts[:index]
        color = Color.smalruby_to_dxruby(opts[:color])
        board.set_neo_pixel_color(opts[:index], *color)
        if opts[:show]
          show
        end
      end

      # apply color settings
      def show
        board.show_neo_pixel
      end

      # turn off
      def turn_off
        if @indexes.length > 0
          @indexes.each do |i|
            board.set_neo_pixel_color(i, 0, 0, 0)
          end
          board.show_neo_pixel
        end
      end

      # destruction
      def stop
        if @indexes.length > 0
          turn_off
          @indexes.clear
        end
      end

      private

      def after_initialize(_ = {})
        board.set_neo_pixel_pin(pin)
        board.show_neo_pixel
      end
    end
  end
end
