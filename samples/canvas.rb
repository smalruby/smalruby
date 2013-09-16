# -*- coding: utf-8 -*-
require 'smalruby'

canvas1 = Canvas.new
canvas1.on(:start) do
  draw_font(0, 0, 'こんにちは', 32)
  line(0, 100, 100, 200, [255, 255, 255])
  box_fill(0, 300, 100, 400, [0, 255, 0])
end
