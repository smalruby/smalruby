# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
LEDを1秒間隔で点滅させます
EOS

# デジタルの13番ピンに接続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  loop do
    led('D13').on
    sleep(1)
    led('D13').off
    sleep(1)
  end
end
