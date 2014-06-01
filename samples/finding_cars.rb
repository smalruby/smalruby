# -*- coding: utf-8 -*-
require "smalruby"

canvas1 = Stage.new(color: 'black')

car1 = Character.new(x: 0, y: 148, costume: "car1.png", visible: false, rotation_style: :left_right)
car2 = Character.new(x: 639, y: 148, costume: "car2.png", visible: false, rotation_style: :left_right)
car3 = Character.new(x: 0, y: 348, costume: "car3.png", visible: false, rotation_style: :left_right)
car4 = Character.new(x: 639, y: 348, costume: "car4.png", visible: false, rotation_style: :left_right)

canvas1.on(:start) do
  draw_font(x: 0, y: 0, string: "画面をクリックして隠れている車を4つ探してね", size: 32)
  draw_font(x: 0, y: 32, string: "ヒント１：線の少し上だよ", size: 24)
  draw_font(x: 0, y: 56, string: "ヒント２：上下に2台ずつだよ", size: 24)
  draw_font(x: 0, y: 80, string: "ヒント３：クリックの色は白→青→緑→赤の順に車に近いよ", size: 24)
  box_fill(left: 0, top: 200, right: 639, bottom: 204, color: "white")
  box_fill(left: 0, top: 400, right: 639, bottom: 404, color: "white")

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
    box_fill(left: 0, top: 450, right: 639, bottom: 479, color: "black")
    if のこり台数 == 0
      draw_font(x: 0, y: 450, string: "やったね、全部見つけたよ！！", size: 24)
    else
      draw_font(x: 0, y: 450, string: "あと#{ のこり台数 }台みつけてね", size: 24)
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
      color = "red"
    elsif !car1.visible && car1.distance(x, y) < 64 ||
        !car2.visible && car2.distance(x, y) < 64 ||
        !car3.visible && car3.distance(x, y) < 64 ||
        !car4.visible && car4.distance(x, y) < 64
      color = "green"
    elsif !car1.visible && car1.distance(x, y) < 128 ||
        !car2.visible && car2.distance(x, y) < 128 ||
        !car3.visible && car3.distance(x, y) < 128 ||
        !car4.visible && car4.distance(x, y) < 128
      color = "blue"
    else
      color = "white"
    end
    circle_fill(x: 9, y: 9, r: 9, color: color)
    sleep(0.5)
    vanish
  end
end

car1.on(:start) do
  speed = rand(1..5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car1.on(:click) do
  self.visible = true
end

car2.on(:start) do
  speed = rand(10..15)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car2.on(:click) do
  self.visible = true
end

car3.on(:start) do
  speed = rand(1..5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car3.on(:click) do
  self.visible = true
end

car4.on(:start) do
  speed = rand(10..15)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
car4.on(:click) do
  self.visible = true
end
