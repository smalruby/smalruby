require 'smalruby'

car1 = Car.new
car1.on(:start) do
  loop do
    move(10)
    turn_if_reach_wall
  end
end
