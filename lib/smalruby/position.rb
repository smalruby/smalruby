# -*- coding: utf-8 -*-

module Smalruby
  # Scratch's position
  #
  # x range is -240(left) - 240(right)
  # y range is -240(bottom) - 240(top)
  class Position
    def self.left
      @left ||= -(Window.width / 2)
    end

    def self.right
      @right ||= Window.width / 2
    end

    def self.top
      @top ||= Window.height / 2
    end

    def self.bottom
      @bottom ||= -(Window.height / 2)
    end

    attr_reader :x
    attr_reader :y

    def initialize(character, x, y)
      @character = character
      self.x = x
      self.y = y
    end

    def x=(val)
      if val < self.class.left
        val = self.class.left
      elsif val > self.class.right
        val = self.class.right
      end
      @x = val
      #p([@character, @x, @y, dxruby_x, dxruby_y]) rescue nil
    end

    def y=(val)
      if val < self.class.bottom
        val = self.class.bottom
      elsif val > self.class.top
        val = self.class.top
      end
      @y = val
      #p([@character, @x, @y, dxruby_x, dxruby_y]) rescue nil
    end

    def to_a
      [@x, @y]
    end

    def to_s
      to_a.to_s
    end

    def dxruby_x
      @x + self.class.right - @character.image.width / 2
    end

    def dxruby_y
      -(@y - self.class.top) - @character.image.height / 2
    end

    def dxruby_xy
      [dxruby_x, dxruby_y]
    end
  end
end
