# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
Smalrubot on Studuino v1を操作します
EOS

require 'smalruby'

init_hardware

stage1 = Stage.new(color: 'white')

stage1.on(:start) do
  fill(color: 'white')
  draw_font(string: DESCRIPTION, color: 'black')

  smalrubot_s1.left_dc_motor_pace_ratio = 100
  smalrubot_s1.right_dc_motor_pace_ratio = 100

  loop do
    if Input.key_down?(K_UP)
      fill(color: 'white')
      draw_font(string: '進む', color: 'black')

      smalrubot_s1.forward

      await until !Input.key_down?(K_UP)

      [75, 50, 25].each do |ratio|
        smalrubot_s1.left_dc_motor_pace_ratio = ratio
        smalrubot_s1.right_dc_motor_pace_ratio = ratio
        sleep(0.1)
      end

      fill(color: 'white')

      smalrubot_s1.left_dc_motor_pace_ratio = 100
      smalrubot_s1.right_dc_motor_pace_ratio = 100

      smalrubot_s1.stop
    end

    if Input.key_down?(K_DOWN)
      fill(color: 'white')
      draw_font(string: 'バックする', color: 'black')

      smalrubot_s1.backward

      await until !Input.key_down?(K_DOWN)

      fill(color: 'white')

      smalrubot_s1.stop
    end

    if Input.key_down?(K_LEFT)
      fill(color: 'white')
      draw_font(string: '左に旋回する', color: 'black')

      smalrubot_s1.turn_left

      await until !Input.key_down?(K_LEFT)

      fill(color: 'white')

      smalrubot_s1.stop
    end

    if Input.key_down?(K_RIGHT)
      fill(color: 'white')
      draw_font(string: '右に旋回する', color: 'black')

      smalrubot_s1.turn_right

      await until !Input.key_down?(K_RIGHT)

      fill(color: 'white')

      smalrubot_s1.stop
    end

    if Input.key_down?(K_S)
      until !Input.key_down?(K_S)
        fill(color: 'white')
        draw_font(string: "ライントレーサーの情報: 左(#{smalrubot_s1.left_ir_photoreflector_value}) 右(#{smalrubot_s1.right_ir_photoreflector_value})",
                  color: 'black')
        await
      end

      fill(color: 'white')
    end

    if Input.key_down?(K_W)
      fill(color: 'white')
      draw_font(string: '白色LEDを光らせる', color: 'black')

      smalrubot_s1.turn_on_white_led

      await until !Input.key_down?(K_W)

      fill(color: 'white')

      smalrubot_s1.turn_off_white_led
    end

    if Input.key_down?(K_B)
      fill(color: 'white')
      draw_font(string: '青色LEDを光らせる', color: 'black')

      smalrubot_s1.turn_on_blue_led

      await until !Input.key_down?(K_B)

      fill(color: 'white')

      smalrubot_s1.turn_off_blue_led
    end
  end
end

stage1.on(:key_push, K_A) do
  loop do
    fill(color: 'white')
    draw_font(string: '自動運転', color: 'black')

    smalrubot_s1.forward

    loop do
      if smalrubot_s1.left_ir_photoreflector_value < 300 && smalrubot_s1.right_ir_photoreflector_value < 300
        fill(color: 'white')
        draw_font(string: '前方障害物発見！', color: 'black')

        smalrubot_s1.backward
        sleep(0.25)
        if rand(2) == 1
          smalrubot_s1.turn_left
          sleep(0.1)
        else
          smalrubot_s1.turn_right
          sleep(0.1)
        end
        break
      end

      if smalrubot_s1.left_ir_photoreflector_value < 300
        fill(color: 'white')
        draw_font(string: '左側障害物発見！', color: 'black')

        smalrubot_s1.backward
        sleep(0.25)
        smalrubot_s1.turn_right
        sleep(0.1)
        break
      end

      if smalrubot_s1.right_ir_photoreflector_value < 300
        fill(color: 'white')
        draw_font(string: '右側障害物発見！', color: 'black')

        smalrubot_s1.backward
        sleep(0.25)
        smalrubot_s1.turn_left
        sleep(0.1)
        break
      end

      if Input.key_down?(K_Y)
        fill(color: 'white')
        break
      end
    end
    smalrubot_s1.stop
    sleep(0.1)

    if Input.key_down?(K_Y)
      fill(color: 'white')
      break
    end
  end
end
