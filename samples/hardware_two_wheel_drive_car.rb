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
    two_wheel_drive_car('D5').forward
    sleep(2)
    two_wheel_drive_car('D5').backward
    sleep(2)
    two_wheel_drive_car('D5').turn_left
    sleep(0.5)
    two_wheel_drive_car('D5').turn_right
    sleep(0.5)
    two_wheel_drive_car('D5').stop
    sleep(1)
  end
end

stage1.on(:key_push, K_E) do
  two_wheel_drive_car('D5').left_speed += 1

  fill(color: 'white')
  draw_font(string: "速度%: 左< #{two_wheel_drive_car('D5').left_speed} > 右< #{two_wheel_drive_car('D5').right_speed} >", color: 'black')
end

stage1.on(:key_push, K_D) do
  two_wheel_drive_car('D5').left_speed -= 1

  fill(color: 'white')
  draw_font(string: "速度%: 左< #{two_wheel_drive_car('D5').left_speed} > 右< #{two_wheel_drive_car('D5').right_speed} >", color: 'black')
end

stage1.on(:key_push, K_UP) do
  two_wheel_drive_car('D5').right_speed += 1

  fill(color: 'white')
  draw_font(string: "速度%: 左< #{two_wheel_drive_car('D5').left_speed} > 右< #{two_wheel_drive_car('D5').right_speed} >", color: 'black')
end

stage1.on(:key_push, K_DOWN) do
  two_wheel_drive_car('D5').right_speed -= 1

  fill(color: 'white')
  draw_font(string: "速度%: 左< #{two_wheel_drive_car('D5').left_speed} > 右< #{two_wheel_drive_car('D5').right_speed} >", color: 'black')
end
