# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
マイコン内蔵RGB LEDを制御します
EOS

# デジタルの5番ピンに接続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  loop do
    Color::NAME_TO_CODE.keys.each do |color|
      draw_font(string: "#{DESCRIPTION}#{color}", color: 'black')
      neo_pixel('D5').set(color: color)
      sleep(1)
      fill(color: 'white')
    end
  end
end
