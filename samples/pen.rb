# -*- coding: utf-8 -*-
require 'smalruby'

car1 = Character.new(x: 0, y: 0, costume: 'car1.png', rotation_style: :left_right)

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

car1.on(:key_down, K_LEFT) do
  self.x -= 10
end

car1.on(:key_down, K_RIGHT) do
  self.x += 10
end

car1.on(:key_down, K_UP) do
  self.y -= 10
end

car1.on(:key_down, K_DOWN) do
  self.y += 10
end
