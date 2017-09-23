# -*- coding: utf-8 -*-

module Smalruby
  class AbstructPosition
    def self.adjust_angle(val)
      val
    end

    attr_reader :x
    attr_reader :y

    def initialize(character, x, y)
      @character = character
      self.x = x
      self.y = y
    end

    def width
      if @character
        @character.image.width
      else
        0
      end
    end

    def height
      if @character
        @character.image.height
      else
        0
      end
    end

    def x=(val)
      @x = val
      #p([@character, @x, @y, dxruby_x, dxruby_y, scratch_x, scratch_y])
    end

    def y=(val)
      @y = val
      #p([@character, @x, @y, dxruby_x, dxruby_y, scratch_x, scratch_y])
    end

    def to_a
      [@x, @y]
    end

    def to_s
      to_a.to_s
    end

    def dxruby_xy
      [dxruby_x, dxruby_y]
    end

    def scratch_xy
      [scratch_x, scratch_y]
    end
  end

  # Scratch's position
  #
  # x range is -(Window.width / 2)(eft) - (Window.width / 2)(right)
  # y range is -(Window.height / 2)(bottom) - (Window.height / 2)(top)
  class ScratchPosition < AbstructPosition
    DEFAULT_WINDOW_SIZE = [480, 360]

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

    def self.adjust_angle(val)
      val - 90
    end

    def x=(val)
      if val < self.class.left
        val = self.class.left
      elsif val > self.class.right
        val = self.class.right
      end
      super(val)
    end

    def y=(val)
      if val < self.class.bottom
        val = self.class.bottom
      elsif val > self.class.top
        val = self.class.top
      end
      super(val)
    end

    def dxruby_x
      @x + self.class.right - width / 2
    end

    def dxruby_y
      -(@y - self.class.top) - height / 2
    end

    alias scratch_x x
    alias scratch_y y
  end

  # DXRuby's position
  #
  # x range is 0(left) - Window.width(right)
  # y range is 0(top) - Window.height(bottom)
  class DXRubyPosition < AbstructPosition
    DEFAULT_WINDOW_SIZE = [640, 480]

    def self.left
      @left ||= 0
    end

    def self.right
      @right ||= Window.width - 1
    end

    def self.top
      @top ||= 0
    end

    def self.bottom
      @bottom ||= Window.height - 1
    end

    def x=(val)
      if val < self.class.left
        val = self.class.left
      elsif val > self.class.right
        val = self.class.right
      end
      super(val)
    end

    def y=(val)
      if val < self.class.top
        val = self.class.top
      elsif val > self.class.bottom
        val = self.class.bottom
      end
      super(val)
    end

    def scratch_x
      @x - self.class.right / 2 + width / 2
    end

    def scratch_y
      -@y + self.class.bottom / 2 - height / 2
    end

    alias dxruby_x x
    alias dxruby_y y
  end
end
