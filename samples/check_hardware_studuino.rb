# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
Studuinoを操作します
EOS

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  fill(color: 'white')
  draw_font(string: DESCRIPTION, color: 'black')

  stage1.studuino

  loop do
    if Input.key_down?(K_UP)
      fill(color: 'white')
      draw_font(string: '進む', color: 'black')

      studuino.forward

      await until !Input.key_down?(K_UP)

      fill(color: 'white')

      studuino.stop
    end

    if Input.key_down?(K_DOWN)
      fill(color: 'white')
      draw_font(string: 'バックする', color: 'black')

      studuino.backward

      await until !Input.key_down?(K_DOWN)

      fill(color: 'white')

      studuino.stop
    end

    if Input.key_down?(K_LEFT)
      fill(color: 'white')
      draw_font(string: '左に旋回する', color: 'black')

      studuino.turn_left

      await until !Input.key_down?(K_LEFT)

      fill(color: 'white')

      studuino.stop
    end

    if Input.key_down?(K_RIGHT)
      fill(color: 'white')
      draw_font(string: '右に旋回する', color: 'black')

      studuino.turn_right

      await until !Input.key_down?(K_RIGHT)

      fill(color: 'white')

      studuino.stop
    end

    if Input.key_down?(K_B)
      until !Input.key_down?(K_B)
        fill(color: 'white')
        draw_font(string: "ライントレーサーの情報: #{studuino.ir_photoreflector_value}",
                  color: 'black')
        await
      end
      fill(color: 'white')
    end
  end
end

stage1.on(:key_push, K_A) do
  loop do
    fill(color: 'white')
    draw_font(string: '自動運転', color: 'black')

    studuino.forward

    loop do
      if studuino.ir_photoreflector_value < 500
        fill(color: 'white')
        draw_font(string: '前方障害物発見！', color: 'black')

        studuino.backward
        sleep(0.25)
        if rand(2) == 1
          studuino.turn_left
          sleep(0.1)
        else
          studuino.turn_left
          sleep(0.1)
        end
        break
      end

      if Input.key_down?(K_Y)
        fill(color: 'white')
        break
      end
    end
    studuino.stop
    sleep(0.1)

    if Input.key_down?(K_Y)
      fill(color: 'white')
      break
    end
  end
end
