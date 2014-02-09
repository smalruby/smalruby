# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
RGB LED(カソードコモン)の色を変化させます
EOS

# デジタルの3番、4番、6番ピンにそれぞれR、G、Bを接続してく
# ださい。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  loop do
    rgb_led_cathode('D3').on(color: 'red')
    sleep(1)
    rgb_led_cathode('D3').on(color: 'green')
    sleep(1)
    rgb_led_cathode('D3').on(color: 'blue')
    sleep(1)
    rgb_led_cathode('D3').off
    sleep(1)
  end
end
