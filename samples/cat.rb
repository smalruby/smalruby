# -*- coding: utf-8 -*-
require 'smalruby'

cat1 = Character.new(costume: 'cat1.png', x: 300, y: 200)

cat1.on(:click) do
  say(message: 'こんにちは')
end
