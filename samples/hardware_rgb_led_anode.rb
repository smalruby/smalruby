# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
RGB LED(アノードコモン)の色を変化させます
EOS

# デジタルの3番、4番、5番、6番ピンにそれぞれR、コモン、G、Bを接続してく
# ださい。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  loop do
    rgb_led_anode('D3').color = 'red'
    sleep(1)
    rgb_led_anode('D3').color = 'green'
    sleep(1)
    rgb_led_anode('D3').color = 'blue'
    sleep(1)
    rgb_led_anode('D3').turn_off
    sleep(1)
  end
end
