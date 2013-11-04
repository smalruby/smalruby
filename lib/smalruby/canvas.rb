# -*- coding: utf-8 -*-

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
      opt[:costume] = Image.new(opt[:width], opt[:height])
      super(opt)
      image.set_color_key([0, 0, 0])
    end

    # @!group ペン

    def draw_font(option)
      opt = {
        x: 0,
        y: 0,
        string: "",
        size: 32,
        color: "white",
      }.merge(option)
      image.draw_font(opt[:x], opt[:y], opt[:string], Font.new(opt[:size]),
                      Color.smalruby_to_dxruby(opt[:color]))
    end

    def line(option)
      opt = {
        color: "white",
      }.merge(verify_rect_option(option))
      image.line(opt[:left], opt[:top], opt[:right], opt[:bottom],
                 Color.smalruby_to_dxruby(opt[:color]))
    end

    def box(option)
      opt = {
        color: "white",
      }.merge(verify_rect_option(option))
      image.box(opt[:left], opt[:top], opt[:right], opt[:bottom],
                Color.smalruby_to_dxruby(opt[:color]))
    end

    def box_fill(option)
      opt = {
        color: "white",
      }.merge(verify_rect_option(option))
      image.box_fill(opt[:left], opt[:top], opt[:right], opt[:bottom],
                     Color.smalruby_to_dxruby(opt[:color]))
    end

    def circle(option)
      opt = {
        color: "white",
      }.merge(option)
      image.circle(opt[:x], opt[:y], opt[:r],
                   Color.smalruby_to_dxruby(opt[:color]))
    end

    def circle_fill(option)
      opt = {
        color: "white",
      }.merge(option)
      image.circle_fill(opt[:x], opt[:y], opt[:r],
                        Color.smalruby_to_dxruby(opt[:color]))
    end

    def_delegators :image, :clear

    # @!endgroup

    private

    def verify_rect_option(option)
      return {
        left: option[:x1],
        top: option[:y1],
        right: option[:x2],
        bottom: option[:y2],
      }.merge(option)
    end
  end
end
