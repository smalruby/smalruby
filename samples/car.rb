require 'smalruby'

car1 = Car.new
car1.on(:start) do
  speed = 10 + rand(20)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end

car2 = Car.new(0, 200)
car2.on(:start) do
  speed = 2 + rand(5)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end

car3 = Car.new(0, 350)
car3.on(:start) do
  speed = 1 + rand(10)
  loop do
    move(speed)
    turn_if_reach_wall
  end
end
