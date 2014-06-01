# -*- coding: utf-8 -*-
require 'smalruby'

# @author: Akihiro Sada
# @license: MIT Lisence
class Tree
  def initialize(canvas)
    @x = 320
    @y = 480
    @radian = -Math::PI / 2
    @canvas = canvas
  end

  def draw(level)
    if level <= 0
      return
    end
    length = level * 5
    forward(length)
    degree = 20
    turn(degree)
    draw(level - 1)
    turn(-degree * 2)
    draw(level - 1)
    turn(degree)
    backward(length)
  end

  private

  def forward(length)
    x = @x
    y = @y
    @x += Math.cos(@radian) * length
    @y += Math.sin(@radian) * length
    @canvas.line(x1: x, y1: y, x2: @x, y2: @y, color: "green")
  end

  def backward(length)
    @x -= Math.cos(@radian) * length
    @y -= Math.sin(@radian) * length
  end

  def turn(degree)
    @radian += degree * Math::PI / 180
  end
end

background = Canvas.new
tree = Tree.new(background)
background.on(:start) do
  tree.draw(12)
end
