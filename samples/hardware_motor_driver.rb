# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
モータードライバ(TA7291P)を操作します
EOS

# デジタルの6～11番ピンをそれぞれ左右のモーター用のモータードライバ
# (TA7291P)の4・5・6に接続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  fill(color: 'white')
  draw_font(string: DESCRIPTION, color: 'black')

  motor_driver('D6').speed = 100
  motor_driver('D9').speed = 100
end

stage1.on(:key_down, K_UP) do
  fill(color: 'white')
  draw_font(string: '進む', color: 'black')

  motor_driver('D6').forward
  motor_driver('D9').forward

  await until !Input.key_down?(K_UP)

  fill(color: 'white')

  motor_driver('D6').stop
  motor_driver('D9').stop
end

stage1.on(:key_down, K_DOWN) do
  fill(color: 'white')
  draw_font(string: 'バックする', color: 'black')

  motor_driver('D6').backward
  motor_driver('D9').backward

  await until !Input.key_down?(K_DOWN)

  fill(color: 'white')

  motor_driver('D6').stop
  motor_driver('D9').stop
end

stage1.on(:key_down, K_LEFT) do
  fill(color: 'white')
  draw_font(string: '左に旋回する', color: 'black')

  motor_driver('D6').backward
  motor_driver('D9').forward

  await until !Input.key_down?(K_LEFT)

  fill(color: 'white')

  motor_driver('D6').stop
  motor_driver('D9').stop
end

stage1.on(:key_down, K_RIGHT) do
  fill(color: 'white')
  draw_font(string: '右に旋回する', color: 'black')

  motor_driver('D6').forward
  motor_driver('D9').backward

  await until !Input.key_down?(K_RIGHT)

  fill(color: 'white')

  motor_driver('D6').stop
  motor_driver('D9').stop
end

stage1.on(:key_push, K_W) do
  motor_driver('D6').speed += 10

  fill(color: 'white')
  draw_font(string: "左の速度: #{motor_driver('D6').speed}%", color: 'black')
end

stage1.on(:key_push, K_S) do
  motor_driver('D6').speed -= 10

  fill(color: 'white')
  draw_font(string: "左の速度: #{motor_driver('D6').speed}%", color: 'black')
end

stage1.on(:key_push, K_O) do
  motor_driver('D9').speed += 10

  fill(color: 'white')
  draw_font(string: "右の速度: #{motor_driver('D9').speed}%", color: 'black')
end

stage1.on(:key_push, K_L) do
  motor_driver('D9').speed -= 10

  fill(color: 'white')
  draw_font(string: "右の速度: #{motor_driver('D9').speed}%", color: 'black')
end
