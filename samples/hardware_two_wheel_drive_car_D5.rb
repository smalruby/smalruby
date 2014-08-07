# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
D5に接続した2WD車を操作します
EOS

# PWM出力可能なデジタルの5番・6番ピンに左のモーター、10番・9番ピンに右
# のモーターを接続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  loop do
    two_wheel_drive_car('D5').forward
    sleep(0.5)
    two_wheel_drive_car('D5').backward
    sleep(0.5)
    two_wheel_drive_car('D5').turn_left
    sleep(0.5)
    two_wheel_drive_car('D5').turn_right
    sleep(0.5)
    two_wheel_drive_car('D5').stop
    sleep(0.5)
  end
end

stage1.on(:start) do
  loop do
    fill(color: 'white')
    draw_font(string: sensor('A0').value.to_s, color: 'black')
  end
end
