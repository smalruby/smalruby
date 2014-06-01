# -*- coding: utf-8 -*-
require 'smalruby'

car1 = Character.new(x: 0, y: 0, costume: 'car1.png', rotation_style: :free)

car1.on(:start) do
  loop do
    if enable_pen
      say(message: 'ペンを下げる')
    else
      say(message: 'ペンを上げる')
    end
  end
end

car1.on(:click) do
  if enable_pen
    up_pen
  else
    down_pen
  end
end

car1.on(:key_push, K_1) do
  self.pen_color = 'red'
end

car1.on(:key_push, K_2) do
  self.pen_color = 'blue'
end

car1.on(:key_push, K_3) do
  self.pen_color = 'green'
end

car1.on(:key_push, K_4) do
  self.pen_color = 'black'
end

car1.on(:key_down, K_LEFT) do
  rotate(-15)
end

car1.on(:key_down, K_RIGHT) do
  rotate(15)
end

car1.on(:key_down, K_UP) do
  move(30)
end

car1.on(:key_down, K_DOWN) do
  move(-30)
end
