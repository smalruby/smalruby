# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
マイコン内蔵RGB LEDを制御します
EOS

# マイコン内蔵RGB LEDデジタルの5番ピンに、
# スイッチをデジタルの3・4番ピンに接続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  color_codes = Color::NAME_TO_CODE.keys
  index = 0
  loop do
    fill(color: 'white')
    color = color_codes[index]
    draw_font(string: "#{DESCRIPTION}#{index}:#{color}", color: 'black')
    neo_pixel("D5").set(color: color)
    until button("D3").pressed? || button("D4").pressed?
      await
    end
    if button("D3").pressed?
      index -= 1
      if index < 0
        index = 0
      end
    end
    if button("D4").pressed?
      index += 1
      if index >= color_codes.length
        index = color_codes.length - 1
      end
    end
  end
end
