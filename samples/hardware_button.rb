# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
ハードウェアのボタンを操作します
EOS

# デジタルの3番ピンにボタンを接続してください。

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')
frog1 = Character.new(costume: 'frog1.png', x: 300, y: 200, visible: false)

stage1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  if button('D3').up?
    frog1.visible = false
  else
    frog1.visible = true
  end
end

stage1.on(:button_down, 'D3') do
  frog1.visible = true
end

stage1.on(:button_up, 'D3') do
  frog1.visible = false
end
