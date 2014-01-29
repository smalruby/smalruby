# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
LEDを1秒間隔で点滅させます
EOS

require 'smalruby'

init_hardware(device: 'COM5')

scene1 = Scene.new(color: 'white')

scene1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  loop do
    led(13).on
    sleep(1)
    led(13).off
    sleep(1)
  end
end
