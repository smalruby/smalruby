require 'smalruby'

car1 = Car.new(0, 0, 1)
car1.on(:start) do
  @visible = false
  loop do
    move(1 + rand(20))
    turn_if_reach_wall
  end
end
car1.on(:click) do
  @visible = true
end

car2 = Car.new(0, 100, 2)
car2.on(:start) do
  @visible = false
  loop do
    move(1 + rand(20))
    turn_if_reach_wall
  end
end
car2.on(:click) do
  @visible = true
end

car3 = Car.new(0, 200, 3)
car3.on(:start) do
  @visible = false
  loop do
    move(1 + rand(20))
    turn_if_reach_wall
  end
end
car3.on(:click) do
  @visible = true
end

car4 = Car.new(0, 300, 4)
car4.on(:start) do
  @visible = false
  loop do
    move(1 + rand(20))
    turn_if_reach_wall
  end
end
car4.on(:click) do
  @visible = true
end
