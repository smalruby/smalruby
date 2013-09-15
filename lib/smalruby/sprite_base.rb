# -*- coding: utf-8 -*-
require 'forwardable'

module Smalruby
  # 操作対象のベースクラス
  class SpriteBase < Base
    def initialize(x, y, path)
      @sprite = Sprite.new(x, y, Image.load(path))
      @vector = { x: 1, y: 0 }
      super()
    end

    # @!group 動き

    def move(val = 1)
      self.x += @vector[:x] * val
      self.y += @vector[:y] * val
    end

    def turn_if_reach_wall
      max_width = Window.width - @sprite.image.width
      if x < 0
        self.x = 0
        @vector[:x] = 1
        @vector[:y] = 0
      elsif x >= max_width
        self.x = max_width - 1
        @vector[:x] = -1
        @vector[:y] = 0
      end
    end

    # @!endgroup

    def_delegators :@sprite, :x, :x=, :y, :y=, :draw, :===, :check, :vanish, :vanished?
  end
end
