# -*- coding: utf-8 -*-
require 'smalruby'

car1 = Character.new(x: 0, y: 0, costume: 'extra_car2.png')

car1.on(:start) do
  loop do
    move(5)
    if reach_wall?
      turn
    end
  end
end
