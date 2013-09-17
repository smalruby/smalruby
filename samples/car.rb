require 'smalruby'

car1 = Character.new(0, 0, 'car1.png')
car1.on(:start) do
  loop do
    move(5)
    turn_if_reach_wall
  end
end
car1.on(:click) do
  turn
end
