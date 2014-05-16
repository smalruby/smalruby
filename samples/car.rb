# -*- coding: utf-8 -*-
require 'smalruby'

car1 = Character.new(x: 0, y: 0, costume: 'car1.png', rotation_style: :left_right)

car1.on(:start) do
  loop do
    move(15)
    turn_if_reach_wall
  end
end

car1.on(:click) do
  rotate(15)
end

car1.on(:key_push, K_1) do
  self.rotation_style = :free
end

car1.on(:key_push, K_2) do
  self.rotation_style = :left_right
end

car1.on(:key_push, K_3) do
  self.rotation_style = :none
end
