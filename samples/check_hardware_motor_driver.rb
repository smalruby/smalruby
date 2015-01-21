# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
モータードライバ(TA7291P)を操作します
EOS

# デジタルの6～11番ピンをそれぞれ左右のモーター用のモータードライバ
# (TA7291P)の4・5・6に接続してください。

require 'smalruby'

init_hardware

Smalrubot.debug_mode = true

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  fill(color: 'white')
  draw_font(string: DESCRIPTION, color: 'black')

  motor_driver('D6').speed = 100
  motor_driver('D9').speed = 100

  loop do
    if Input.key_down?(K_UP)
      fill(color: 'white')
      draw_font(string: '進む', color: 'black')

      motor_driver('D6').forward
      motor_driver('D9').forward

      await until !Input.key_down?(K_UP)

      fill(color: 'white')

      motor_driver('D6').stop
      motor_driver('D9').stop
      sleep(0.2)
    end

    if Input.key_down?(K_DOWN)
      fill(color: 'white')
      draw_font(string: 'バックする', color: 'black')

      motor_driver('D6').backward
      motor_driver('D9').backward

      await until !Input.key_down?(K_DOWN)

      fill(color: 'white')

      motor_driver('D6').stop
      motor_driver('D9').stop
      sleep(0.2)
    end

    if Input.key_down?(K_LEFT)
      fill(color: 'white')
      draw_font(string: '左に旋回する', color: 'black')

      motor_driver('D6').backward
      motor_driver('D9').forward

      await until !Input.key_down?(K_LEFT)

      fill(color: 'white')

      motor_driver('D6').stop
      motor_driver('D9').stop
      sleep(0.2)
    end

    if Input.key_down?(K_RIGHT)
      fill(color: 'white')
      draw_font(string: '右に旋回する', color: 'black')

      motor_driver('D6').forward
      motor_driver('D9').backward

      await until !Input.key_down?(K_RIGHT)

      fill(color: 'white')

      motor_driver('D6').stop
      motor_driver('D9').stop
      sleep(0.2)
    end

    if Input.key_down?(K_W)
      motor_driver('D6').speed += 10

      fill(color: 'white')
      draw_font(string: "左の速度: #{motor_driver('D6').speed}%", color: 'black')
    end

    if Input.key_down?(K_S)
      motor_driver('D6').speed -= 10

      fill(color: 'white')
      draw_font(string: "左の速度: #{motor_driver('D6').speed}%", color: 'black')
    end

    if Input.key_down?(K_O)
      motor_driver('D9').speed += 10

      fill(color: 'white')
      draw_font(string: "右の速度: #{motor_driver('D9').speed}%", color: 'black')
    end

    if Input.key_down?(K_L)
      motor_driver('D9').speed -= 10

      fill(color: 'white')
      draw_font(string: "右の速度: #{motor_driver('D9').speed}%", color: 'black')
    end

    if Input.key_down?(K_SPACE)
      fill(color: 'white')
      draw_font(string: '右のLED赤色を光らせる', color: 'black')

      led('D13').on

      await until !Input.key_down?(K_SPACE)

      led('D13').off

      fill(color: 'white')
      draw_font(string: '左のLED緑色を光らせる', color: 'black')

      led('D2').on

      sleep(1)

      led('D2').off
    end

    if Input.key_down?(K_B)
      until !Input.key_down?(K_B)
        fill(color: 'white')
        draw_font(string: "センサーの情報#{sensor('A0').value}", color: 'black')
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

    puts("R: #{button('D3').on? ? 'T' : 'F'}, L: #{button('D4').on? ? 'T' : 'F'}")

    if button('D3').on? && button('D4').on?
      fill(color: 'white')
      draw_font(string: '前方障害物発見！', color: 'black')

      motor_driver('D6').backward
      motor_driver('D9').backward
      sleep(0.5)
      motor_driver('D6').stop
      motor_driver('D9').stop

      if rand(2) == 1
        motor_driver('D6').forward
        motor_driver('D9').backward
        sleep(0.2)
        motor_driver('D6').stop
        motor_driver('D9').stop
      else
        motor_driver('D6').backward
        motor_driver('D9').forward
        sleep(0.2)
        motor_driver('D6').stop
        motor_driver('D9').stop
      end
      next
    end
    if button('D3').on?
      fill(color: 'white')
      draw_font(string: '右側障害物発見！', color: 'black')

      motor_driver('D6').backward
      motor_driver('D9').backward
      sleep(0.2)
      motor_driver('D6').stop
      motor_driver('D9').stop

      motor_driver('D6').backward
      motor_driver('D9').forward
      sleep(0.2)
      motor_driver('D6').stop
      motor_driver('D9').stop

      next
    end
    if button('D4').on?
      fill(color: 'white')
      draw_font(string: '左側障害物発見！', color: 'black')

      motor_driver('D6').backward
      motor_driver('D9').backward
      sleep(0.2)
      motor_driver('D6').stop
      motor_driver('D9').stop

      motor_driver('D6').forward
      motor_driver('D9').backward
      sleep(0.2)
      motor_driver('D6').stop
      motor_driver('D9').stop

      next
    end
    motor_driver('D6').forward
    motor_driver('D9').forward
    sleep(0.5)
    motor_driver('D6').stop
    motor_driver('D9').stop

    if Input.key_down?(K_Y)
      fill(color: 'white')
      break
    end
  end
end
