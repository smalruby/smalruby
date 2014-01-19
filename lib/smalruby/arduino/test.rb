require 'dino'
require_relative 'board.rb'
require_relative 'led.rb'
require_relative 'sensor.rb'
require_relative '7segment.rb'

board = Smalruby::Arduino::Board.new

seg = Smalruby::Arduino::SevenSegment.new(board: board, pins: [13,12,11,10,9,8,7,6])

NUMBERS = [
  :zero,
  :one,
  :two,
  :three,
  :four,
  :five,
  :six,
  :seven,
  :eight,
  :nine,
  :off
]

loop do
  NUMBERS.each_with_index do |number, i|
    seg.send(number)
    puts i.to_s
    sleep 1
  end
end