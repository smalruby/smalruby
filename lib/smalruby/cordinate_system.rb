# -*- coding: utf-8 -*-

module Smalruby
  class AbstructCordinateSystem
    def self.dxruby?
      false
    end

    def self.scratch?
      false
    end

    def self.min_x
      [left, right].min
    end

    def self.max_x
      [left, right].max
    end

    def self.min_y
      [top, bottom].min
    end

    def self.max_y
      [top, bottom].max
    end

    def self.adjust_angle(val)
      val
    end

    attr_reader :x
    attr_reader :y

    def initialize(character, x, y)
      @character = character
      @x = 0
      @y = 0
      self.x = x
      self.y = y
    end

    def width
      @character ? @character.image.width * @character.scale_x.abs : 0
    end

    def height
      @character ? @character.image.height * @character.scale_y.abs : 0
    end

    def center_x
      @character ? @character.center_x : 0
    end

    def center_y
      @character ? @character.center_y : 0
    end

    def min_x
      [left, right].min
    end

    def max_x
      [left, right].max
    end

    def min_y
      [top, bottom].min
    end

    def max_y
      [top, bottom].max
    end

    def x=(val)
      if val < self.class.min_x
        val = self.class.min_x
      elsif val > self.class.max_x
        val = self.class.max_x
      end
      @x = val.round
      if debug_mode?
        puts("xy: #{[@x, @y]}, dxruby_xy: #{dxruby_xy}, scratch_xy: #{scratch_xy}")
      end
    end

    def y=(val)
      if val < self.class.min_y
        val = self.class.min_y
      elsif val > self.class.max_y
        val = self.class.max_y
      end
      @y = val.round
      if debug_mode?
        puts("xy: #{[@x, @y]}, dxruby_xy: #{dxruby_xy}, scratch_xy: #{scratch_xy}")
      end
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
  # x range is -((Window.width - 1) / 2)(left) - ((Window.width - 1) / 2)(right)
  # y range is -((Window.height - 1) / 2)(bottom) - ((Window.height - 1) / 2)(top)
  class ScratchCordinateSystem < AbstructCordinateSystem
    DEFAULT_WINDOW_SIZE = [481, 361]

    def self.scratch?
      true
    end

    def self.left
      @left ||= -((Window.width - 1) / 2)
    end

    def self.right
      @right ||= (Window.width - 1) / 2
    end

    def self.top
      @top ||= (Window.height - 1) / 2
    end

    def self.bottom
      @bottom ||= -((Window.height - 1) / 2)
    end

    def self.right_angle
      90
    end

    def self.vector
      { x: 1, y: -1 }
    end

    alias super_center_x center_x
    alias super_center_y center_y

    def left
      x - super_center_x
    end

    def right
      x + (width - super_center_x)
    end

    def top
      y + super_center_y
    end

    def bottom
      y - (height - super_center_y)
    end

    def center_x
      0
    end

    def center_y
      0
    end

    def dxruby_x
      @x + self.class.right - super_center_x
    end

    def dxruby_y
      -(@y - self.class.top) - super_center_y
    end

    def dxruby_x=(val)
      self.x = val - self.class.right - super_center_x
    end

    def dxruby_y=(val)
      self.y = -(val - self.class.top) - super_center_y
    end

    alias scratch_x x
    alias scratch_y y
  end

  # DXRuby's position
  #
  # x range is 0(left) - Window.width(right)
  # y range is 0(top) - Window.height(bottom)
  class DXRubyCordinateSystem < AbstructCordinateSystem
    DEFAULT_WINDOW_SIZE = [640, 480]

    def self.dxruby?
      true
    end

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

    def self.right_angle
      0
    end

    def self.vector
      { x: 1, y: 1 }
    end

    def left
      x
    end

    def right
      x + width
    end

    def top
      y
    end

    def bottom
      y + height
    end

    alias dxruby_x x
    alias dxruby_y y
    alias dxruby_x= x=
    alias dxruby_y= y=

    def scratch_x
      @x - Window.width + center_x
    end

    def scratch_y
      -@y + Window.height / 2 - center_y
    end
  end
end
