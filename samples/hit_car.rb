# -*- coding: utf-8 -*-
require 'smalruby'

car1 = Character.new(x: 0, y: 0, costume: 'car1.png')
car2 = Character.new(x: 639, y: 0, costume: 'car2.png')

car1.when(:start) do
  loop do
    move(5)
    if reach_wall?
      turn
    end
  end
end

car1.when(:hit, car2) do
  move_back(20)
  turn
end

car2.when(:start) do
  loop do
    move(10)
    if reach_wall?
      turn
    end
  end
end

car2.when(:hit, car1) do
  move_back(20)
  turn
end
