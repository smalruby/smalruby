# -*- coding: utf-8 -*-
require 'smalruby'

canvas1 = Canvas.new
canvas1.on(:start) do
  draw_font(x: 0, y: 0, string: 'こんにちは', size: 32)
  line(x1: 0, y1: 100, x2: 100, y2: 200, color: "red")
  box_fill(left: 0, top: 300, right: 100, bottom: 400, color: "green")
end
