# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
スモウルボットV3を操作します
EOS

require 'smalruby'

init_hardware(device: ENV['SMALRUBOT_DEVICE'],
              baud: ENV['SMALRUBOT_BAUD'] ? ENV['SMALRUBOT_BAUD'].to_i : nil)

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
        smalrubot_v3.left_dc_motor_power_ratio += 10
      else
        smalrubot_v3.left_dc_motor_power_ratio -= 10
      end

      fill(color: 'white')
      draw_font(string: "左の速度: #{smalrubot_v3.left_dc_motor_power_ratio}%",
                color: 'black')
    end

    if Input.key_down?(K_O) || Input.key_down?(K_L)
      if Input.key_down?(K_O)
        smalrubot_v3.right_dc_motor_power_ratio += 10
      else
        smalrubot_v3.right_dc_motor_power_ratio -= 10
      end

      fill(color: 'white')
      draw_font(string: "右の速度: #{smalrubot_v3.right_dc_motor_power_ratio}%",
                color: 'black')
    end

    if Input.key_down?(K_SPACE)
      fill(color: 'white')
      draw_font(string: '右のLEDを光らせる', color: 'black')

      smalrubot_v3.turn_on_right_led

      sleep(1)

      smalrubot_v3.turn_off_right_led

      fill(color: 'white')
      draw_font(string: '左のLEDを光らせる', color: 'black')

      smalrubot_v3.turn_on_left_led

      sleep(1)

      smalrubot_v3.turn_off_left_led

      fill(color: 'white')
    end

    if Input.key_down?(K_H)
      until !Input.key_down?(K_H)
        fill(color: 'white')
        msg = 'センサーの情報: ' +
          "左 #{smalrubot_v3.left_sensor_value} " +
          "右 #{smalrubot_v3.right_sensor_value}"
        draw_font(string: msg, color: 'black')
        await
      end
      fill(color: 'white')
    end
  end
end

THRESHOLD = 400

stage1.on(:key_push, K_A) do
  loop do
    fill(color: 'white')
    draw_font(string: '自動運転', color: 'black')

    left_sensor = smalrubot_v3.left_sensor_value < THRESHOLD
    right_sensor = smalrubot_v3.right_sensor_value < THRESHOLD

    if !left_sensor && !right_sensor
      smalrubot_v3.forward
    end

    loop do
      if left_sensor || right_sensor
        if left_sensor && right_sensor
          fill(color: 'white')
          draw_font(string: '前方障害物発見！', color: 'black')

          smalrubot_v3.backward

          loop do
            left_sensor = smalrubot_v3.left_sensor_value < THRESHOLD
            right_sensor = smalrubot_v3.right_sensor_value < THRESHOLD
            if !left_sensor && !right_sensor
              smalrubot_v3.stop
              break
            end
          end

          if rand(2) == 1
            smalrubot_v3.turn_left(sec: 0.1)
          else
            smalrubot_v3.turn_right(sec: 0.1)
          end
        else
          if right_sensor
            fill(color: 'white')
            draw_font(string: '右側障害物発見！', color: 'black')

            #smalrubot_v3.backward(sec: 0.1)
            smalrubot_v3.turn_left

            loop do
              left_sensor = smalrubot_v3.left_sensor_value < THRESHOLD
              right_sensor = smalrubot_v3.right_sensor_value < THRESHOLD
              if !left_sensor && !right_sensor
                smalrubot_v3.stop
                break
              end
            end
          else
            if left_sensor
              fill(color: 'white')
              draw_font(string: '左側障害物発見！', color: 'black')

              #smalrubot_v3.backward(sec: 0.1)
              smalrubot_v3.turn_right

              loop do
                left_sensor = smalrubot_v3.left_sensor_value < THRESHOLD
                right_sensor = smalrubot_v3.right_sensor_value < THRESHOLD
                if !left_sensor && !right_sensor
                  smalrubot_v3.stop
                  break
                end
              end
            end
          end
        end
        break
      end

      if Input.key_down?(K_Y)
        fill(color: 'white')
        break
      end

      left_sensor = smalrubot_v3.left_sensor_value < THRESHOLD
      right_sensor = smalrubot_v3.right_sensor_value < THRESHOLD
    end

    if Input.key_down?(K_Y)
      fill(color: 'white')
      smalrubot_v3.stop
      break
    end
  end
end
