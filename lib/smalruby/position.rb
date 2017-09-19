# -*- coding: utf-8 -*-

module Smalruby
  # Scratch's position
  #
  # x range is -240(left) - 240(right)
  # y range is -240(bottom) - 240(top)
  class Position
    attr_reader :x
    attr_reader :y

    def initialize(character, x, y)
      @character = character
      @x = x
      @y = y
    end

    def x=(val)
      if val < -240
        val = -240
      elsif val >= 240
        val = 240
      end
      @x = val
    end

    def y=(val)
      if val < -240
        val = -240
      elsif val >= 240
        val = 240
      end
      @y = val
    end

    def to_a
      [@x, @y]
    end

    def to_s
      to_a.to_s
    end

    def dxruby_x
      @x + 320
    end

    def dxruby_y
      -(@y - 240)
    end

    def dxruby_xy
      [dxruby_x, dxruby_y]
    end
  end
end
