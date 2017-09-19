# -*- coding: utf-8 -*-
# 電子ピアノをつくろう

require "smalruby"

# ドの鍵盤を作る
key_do = Canvas.new(x: 200, y: 200, width: 30, height: 100)

# (ドの鍵盤) プログラムがはじまった時
key_do.when(:start) do
  # (0, 0)-(29, 99)、"white" 色、四角く塗りつぶす
  box_fill(x1: 0, y1: 0,
           x2: 29, y2: 99,
           color: "white")

  # (0, 0)-(29, 99)、"gray" 色、四角を描く
  box(x1: 0, y1: 0,
      x2: 29, y2: 99,
      color: "gray")
end

# (ドの鍵盤) クリックしたとき
key_do.when(:click) do |x, y|
  play(name: 'piano_do.wav')
end

# レの鍵盤を作る
key_re = Canvas.new(x: 230, y: 200, width: 30, height: 100)

# (レの鍵盤) プログラムがはじまった時
key_re.when(:start) do
  # (0, 0)-(29, 99)、"white" 色、四角く塗りつぶす
  box_fill(x1: 0, y1: 0,
           x2: 29, y2: 99,
           color: "white")

  # (0, 0)-(29, 99)、"gray" 色、四角を描く
  box(x1: 0, y1: 0,
      x2: 29, y2: 99,
      color: "gray")
end

# (レの鍵盤) クリックしたとき
key_re.when(:click) do |x, y|
  play(name: 'piano_re.wav')
end

# ミの鍵盤を作る
key_mi = Canvas.new(x: 260, y: 200, width: 30, height: 100)

# (ミの鍵盤) プログラムがはじまった時
key_mi.when(:start) do
  # (0, 0)-(29, 99)、"white" 色、四角く塗りつぶす
  box_fill(x1: 0, y1: 0,
           x2: 29, y2: 99,
           color: "white")

  # (0, 0)-(29, 99)、"gray" 色、四角を描く
  box(x1: 0, y1: 0,
      x2: 29, y2: 99,
      color: "gray")
end

# (ミの鍵盤) クリックしたとき
key_mi.when(:click) do |x, y|
  play(name: 'piano_mi.wav')
end

# ファ、ソ、ラ、シ、ドを一度に作成する
['fa', 'so', 'ra', 'si', 'do_2'].each.with_index do |name, i|
  key = Canvas.new(x: 290 + i * 30, y: 200, width: 30, height: 100)

  key.when(:start) do
    box_fill(x1: 0, y1: 0, x2: 29, y2: 99, color: "white")
    box(x1: 0, y1: 0, x2: 29, y2: 99, color: "gray")
  end

  key.when(:click) do |x, y|
    play(name: "piano_#{name}.wav")
  end
end
