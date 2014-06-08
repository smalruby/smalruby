# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
2WD車のタイヤ(モーター)を操作します
EOS

# デジタルの6番・7番ピンに左のモーター、8番・9番ピンに右のモーターを接
# 続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  loop do
    two_wheel_drive_car('D6').run(command: 'forward', sec: 2, left_level: 85, right_level: 100)
    sleep(1)
    two_wheel_drive_car('D6').run(command: 'backward', sec: 2, left_level: 85, right_level: 100)
    sleep(1)
    two_wheel_drive_car('D6').run(command: 'turn_left', sec: 2, left_level: 85, right_level: 100)
    sleep(1)
    two_wheel_drive_car('D6').run(command: 'turn_right', sec: 2, left_level: 85, right_level: 100)
    sleep(1)
  end
end
