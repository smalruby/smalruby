# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
スモウルボットV3を操作します
EOS

require 'smalruby'

init_hardware

Smalrubot.debug_mode = true

stage1 = Stage.new(color: 'white')
stage1.smalrubot_v3

stage1.on(:start) do
  fill(color: 'white')
  draw_font(string: DESCRIPTION, color: 'black')

  loop do
    if Input.key_down?(K_UP)
      fill(color: 'white')
      draw_font(string: '進む', color: 'black')

      smalrubot_v3.forward

      await until !Input.key_down?(K_UP)

      fill(color: 'white')

      smalrubot_v3.stop
    end

    if Input.key_down?(K_DOWN)
      fill(color: 'white')
      draw_font(string: 'バックする', color: 'black')

      smalrubot_v3.backward

      await until !Input.key_down?(K_DOWN)

      fill(color: 'white')

      smalrubot_v3.stop
    end

    if Input.key_down?(K_LEFT)
      fill(color: 'white')
      draw_font(string: '左に旋回する', color: 'black')

      smalrubot_v3.turn_left

      await until !Input.key_down?(K_LEFT)

      fill(color: 'white')

      smalrubot_v3.stop
    end

    if Input.key_down?(K_RIGHT)
      fill(color: 'white')
      draw_font(string: '右に旋回する', color: 'black')

      smalrubot_v3.turn_right

      await until !Input.key_down?(K_RIGHT)

      fill(color: 'white')

      smalrubot_v3.stop
    end

    if Input.key_down?(K_W) || Input.key_down?(K_S)
      if Input.key_down?(K_W)
        smalrubot_v3.left_motor.speed += 10
      else
        smalrubot_v3.left_motor.speed -= 10
      end

      fill(color: 'white')
      draw_font(string: "左の速度: #{smalrubot_v3.left_motor.speed}%",
                color: 'black')
    end

    if Input.key_down?(K_O) || Input.key_down?(K_L)
      if Input.key_down?(K_O)
        smalrubot_v3.right_motor.speed += 10
      else
        smalrubot_v3.right_motor.speed -= 10
      end

      fill(color: 'white')
      draw_font(string: "右の速度: #{smalrubot_v3.right_motor.speed}%",
                color: 'black')
    end

    if Input.key_down?(K_SPACE)
      fill(color: 'white')
      draw_font(string: '赤色LEDを光らせる', color: 'black')

      smalrubot_v3.red_led.turn_on

      sleep(1)

      smalrubot_v3.red_led.turn_off

      fill(color: 'white')
      draw_font(string: '緑色LEDを光らせる', color: 'black')

      smalrubot_v3.green_led.turn_on

      sleep(1)

      smalrubot_v3.green_led.turn_off
    end

    if Input.key_down?(K_B)
      until !Input.key_down?(K_B)
        fill(color: 'white')
        draw_font(string: "光センサーの情報: #{smalrubot_v3.light_sensor.value}",
                  color: 'black')
        await
      end
      fill(color: 'white')
    end

    if Input.key_down?(K_H)
      until !Input.key_down?(K_H)
        fill(color: 'white')
        msg = 'タッチセンサーの情報: ' +
          "左 #{smalrubot_v3.left_touch_sensor.on? ? 'ON ' : 'OFF'} " +
          "右 #{smalrubot_v3.right_touch_sensor.on? ? 'ON ' : 'OFF'}"
        draw_font(string: msg, color: 'black')
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

    if smalrubot_v3.left_touch_sensor.on? && smalrubot_v3.right_touch_sensor.on?
      fill(color: 'white')
      draw_font(string: '前方障害物発見！', color: 'black')

      smalrubot_v3.backward(sec: 0.5)
      if rand(2) == 1
        smalrubot_v3.turn_left(sec: 0.2)
      else
        smalrubot_v3.turn_right(sec: 0.2)
      end

      next
    end

    if smalrubot_v3.right_touch_sensor.on?
      fill(color: 'white')
      draw_font(string: '右側障害物発見！', color: 'black')

      smalrubot_v3.backward(sec: 0.5)
      smalrubot_v3.turn_left(sec: 0.2)

      next
    end

    if smalrubot_v3.left_touch_sensor.on?
      fill(color: 'white')
      draw_font(string: '左側障害物発見！', color: 'black')

      smalrubot_v3.backward(sec: 0.5)
      smalrubot_v3.turn_right(sec: 0.2)

      next
    end

    smalrubot_v3.forward(sec: 0.5)

    if Input.key_down?(K_Y)
      fill(color: 'white')
      break
    end
  end
end
