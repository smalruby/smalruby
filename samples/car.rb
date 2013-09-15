require 'smalruby'

car1 = Car.new(0, 0, 1)
car1.on(:start) do
  loop do
    move(5)
    turn_if_reach_wall
  end
end
car1.on(:click) do
  turn
end
