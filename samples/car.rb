require 'smalruby'

car1 = Car.new(0, 0, 1)
car1.on(:start) do
  loop do
    move(5)
    turn_if_reach_wall
  end
end

car2 = Car.new(0, 100, 2)
car2.on(:start) do
  loop do
    move(2)
    turn_if_reach_wall
  end
end

car3 = Car.new(0, 200, 3)
car3.on(:start) do
  loop do
    move(10)
    turn_if_reach_wall
  end
end

car4 = Car.new(0, 300, 4)
car4.on(:start) do
  loop do
    move(1)
    turn_if_reach_wall
  end
end
