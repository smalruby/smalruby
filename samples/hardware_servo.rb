# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
カーソルキーでサーボモーターを操作します
EOS

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  draw_font(string: DESCRIPTION, color: 'black')

  servo('D3').position = 90
end

stage1.on(:key_down, K_UP, K_LEFT) do
  servo('D3').position += 2
end

stage1.on(:key_down, K_DOWN, K_RIGHT) do
  servo('D3').position -= 2
end
