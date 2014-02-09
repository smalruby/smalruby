# -*- coding: utf-8 -*-

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:sensor_change, 'A0') do |value|
  v = sensor('A0').value
  if 0 <= v && v <= 255
    fill(color: 'red')
  end

  if 256 <= v && v <= 511
    fill(color: 'yellow')
  end

  if 512 <= v
    fill(color: 'blue')
  end

  draw_font(string: "センサーの情報：#{v}",  color: 'black')
end
