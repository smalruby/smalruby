# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
2WD車のタイヤ(モーター)を操作します
EOS

# デジタルの2番・3番ピンに左のモーター、4番・5番ピンに右のモーターを接
# 続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  loop do
    two_wheel_drive_car('D6').forward
    sleep(3)
    two_wheel_drive_car('D6').backward
    sleep(3)
    two_wheel_drive_car('D6').turn_left
    sleep(3)
    two_wheel_drive_car('D6').turn_right
    sleep(3)
    two_wheel_drive_car('D6').stop
    sleep(3)
  end
end
