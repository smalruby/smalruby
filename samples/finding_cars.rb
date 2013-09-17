# -*- coding: utf-8 -*-
require 'smalruby'

canvas1 = Canvas.new
canvas1.on(:start) do
  draw_font(0, 0, '画面をクリックして隠れている車を4つ探してね', 32)
  draw_font(0, 32, <<-EOS, 24)
ヒント１：線の少し上だよ
ヒント２：上下に2台ずつだよ
  EOS
  box_fill(0, 200, 639, 204, [255, 255, 255])
  box_fill(0, 400, 639, 404, [255, 255, 255])
end

car1 = Base.new(0, 148, 'car1.png')
car1.visible = false
car1.on(:start) do
  speed = 1 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car1.on(:click) do
  @visible = true
end

car2 = Base.new(639, 148, 'car2.png')
car2.visible = false
car2.on(:start) do
  speed = 10 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car2.on(:click) do
  @visible = true
end

car3 = Base.new(0, 348, 'car3.png')
car3.visible = false
car3.on(:start) do
  speed = 1 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car3.on(:click) do
  @visible = true
end

car4 = Base.new(639, 348, 'car4.png')
car4.visible = false
car4.on(:start) do
  speed = 10 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car4.on(:click) do
  @visible = true
end
