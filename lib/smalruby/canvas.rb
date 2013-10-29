# -*- coding: utf-8 -*-
require 'readline'

module Smalruby
  # お絵かきを表現するクラス
  class Canvas < Character
    def initialize(option = {})
      opt = {
        x: 0,
        y: 0,
        width: Window.width,
        height: Window.height,
      }.merge(option)
      super(opt[:x], opt[:y], Image.new(opt[:width], opt[:height]))
      self.image.set_color_key([0, 0, 0])
    end

    # @!group ペン

    def draw_font(x, y, string, font_size, color = [255, 255, 255])
      self.image.draw_font(x, y, string, Font.new(font_size), color)
    end

    def_delegators :image,
                   :line, :box, :box_fill, :circle, :circle_fill, :clear

    # @!endgroup
  end
end
