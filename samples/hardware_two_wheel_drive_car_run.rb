# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
2WD車のタイヤ(モーター)を操作します
EOS

# PWM出力可能なデジタルの5番・6番ピンに左のモーター、10番・9番ピンに右
# のモーターを接続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  loop do
    two_wheel_drive_car('D5').run(command: 'forward', sec: 2)
    two_wheel_drive_car('D5').run(command: 'backward', sec: 2)
    two_wheel_drive_car('D5').run(command: 'turn_left', sec: 2)
    two_wheel_drive_car('D5').run(command: 'turn_right', sec: 2)
    two_wheel_drive_car('D5').run(command: 'stop', sec: 2)
  end
end
