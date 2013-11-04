# -*- coding: utf-8 -*-
require 'smalruby'

console1 = Console.new

console1.on(:start) do
  loop do
    input = readline('> ')
    if !input || input.empty?
      break
    end
    system(input)
    if system_failed?
      puts(['command not found: ', input].join)
    end
  end
end
