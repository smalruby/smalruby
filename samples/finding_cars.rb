# -*- coding: utf-8 -*-
require 'smalruby'

canvas1 = Canvas.new
car1 = Character.new(0, 148, 'car1.png', visible: false)
car2 = Character.new(639, 148, 'car2.png', visible: false)
car3 = Character.new(0, 348, 'car3.png', visible: false)
car4 = Character.new(639, 348, 'car4.png', visible: false)

canvas1.on(:start) do
  draw_font(0, 0, '画面をクリックして隠れている車を4つ探してね', 32)
  draw_font(0, 32, "ヒント１：線の少し上だよ", 24)
  draw_font(0, 56, "ヒント２：上下に2台ずつだよ", 24)
  draw_font(0, 80, "ヒント３：クリックの色は白→青→緑→赤の順に車に近いよ", 24)
  box_fill(0, 200, 639, 204, [255, 255, 255])
  box_fill(0, 400, 639, 404, [255, 255, 255])

  loop do
    のこり台数 = 0
    if !car1.visible
      のこり台数 += 1
    end
    if !car2.visible
      のこり台数 += 1
    end
    if !car3.visible
      のこり台数 += 1
    end
    if !car4.visible
      のこり台数 += 1
    end
    box_fill(0, 450, 639, 479, [0, 0, 0])
    if のこり台数 == 0
      draw_font(0, 450, 'やったね、全部見つけたよ！！', 24)
    else
      draw_font(0, 450, "あと#{ のこり台数 }台みつけてね", 24)
    end
  end
end
canvas1.on(:click, :left) do |x, y|
  canvas2 = Canvas.new(x: x - 9, y: y - 9, width: 20, height: 20)
  canvas2.on(:start) do
    if !car1.visible && car1.distance(x, y) < 32 ||
        !car2.visible && car2.distance(x, y) < 32 ||
        !car3.visible && car3.distance(x, y) < 32 ||
        !car4.visible && car4.distance(x, y) < 32
      color = [255, 0, 0]
    elsif !car1.visible && car1.distance(x, y) < 64 ||
        !car2.visible && car2.distance(x, y) < 64 ||
        !car3.visible && car3.distance(x, y) < 64 ||
        !car4.visible && car4.distance(x, y) < 64
      color = [0, 255, 0]
    elsif !car1.visible && car1.distance(x, y) < 128 ||
        !car2.visible && car2.distance(x, y) < 128 ||
        !car3.visible && car3.distance(x, y) < 128 ||
        !car4.visible && car4.distance(x, y) < 128
      color = [0, 0, 255]
    else
      color = [255, 255, 255]
    end
    circle_fill(9, 9, 9, color)
    sleep(0.5)
    vanish
  end
end

car1.on(:start) do
  speed = 1 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car1.on(:click) do
  self.visible = true
end

car2.on(:start) do
  speed = 10 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car2.on(:click) do
  self.visible = true
end

car3.on(:start) do
  speed = 1 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car3.on(:click) do
  self.visible = true
end

car4.on(:start) do
  speed = 10 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car4.on(:click) do
  self.visible = true
end
