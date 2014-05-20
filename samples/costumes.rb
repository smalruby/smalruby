# -*- coding: utf-8 -*-
require 'smalruby'

ryu1 = Character.new(x: 0, y: 0, costume: ['ryu1.png', 'ryu2.png'], angle: 0, rotation_style: :left_right)
taichi1 = Character.new(x: 0, y: 200, costume: ['taichi1.png', 'taichi2.png'], angle: 80, rotation_style: :left_right)

ryu1.on(:start) do
  loop do
    move(10)
    turn_if_reach_wall
    await
    next_costume
  end
end

taichi1.on(:start) do
  loop do
    move(15)
    turn_if_reach_wall
    await
    next_costume
  end
end
