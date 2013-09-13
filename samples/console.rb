require 'smalruby'

console1 = Console.new
console1.on(:start) do
  loop do
    input = readline('> ')
    if !input || input.empty?
      break
    end
    system(input)
  end
end

start
