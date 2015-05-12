# -*- coding: utf-8 -*-

def setup_smalrubot(stage1, smalrubot)
  stage1.on(:start) do
    fill(color: 'white')
    draw_font(string: DESCRIPTION, color: 'black')

    smalrubot.left_dc_motor_power_ratio = 100
    smalrubot.right_dc_motor_power_ratio = 100

    loop do
      if Input.key_down?(K_UP)
        fill(color: 'white')
        draw_font(string: '進む', color: 'black')

        smalrubot.forward

        await until !Input.key_down?(K_UP)

        fill(color: 'white')

        smalrubot.stop
      end

      if Input.key_down?(K_DOWN)
        fill(color: 'white')
        draw_font(string: 'バックする', color: 'black')

        smalrubot.backward

        await until !Input.key_down?(K_DOWN)

        fill(color: 'white')

        smalrubot.stop
      end

      if Input.key_down?(K_LEFT)
        fill(color: 'white')
        draw_font(string: '左に旋回する', color: 'black')

        smalrubot.turn_left

        await until !Input.key_down?(K_LEFT)

        fill(color: 'white')

        smalrubot.stop
      end

      if Input.key_down?(K_RIGHT)
        fill(color: 'white')
        draw_font(string: '右に旋回する', color: 'black')

        smalrubot.turn_right

        await until !Input.key_down?(K_RIGHT)

        fill(color: 'white')

        smalrubot.stop
      end

      if Input.key_down?(K_W) || Input.key_down?(K_S)
        if Input.key_down?(K_W)
          smalrubot.left_dc_motor_power_ratio += 10
        else
          smalrubot.left_dc_motor_power_ratio -= 10
        end

        fill(color: 'white')
        draw_font(string: "左の速度: #{smalrubot.left_dc_motor_power_ratio}%",
                  color: 'black')
      end

      if Input.key_down?(K_O) || Input.key_down?(K_L)
        if Input.key_down?(K_O)
          smalrubot.right_dc_motor_power_ratio += 10
        else
          smalrubot.right_dc_motor_power_ratio -= 10
        end

        fill(color: 'white')
        draw_font(string: "右の速度: #{smalrubot.right_dc_motor_power_ratio}%",
                  color: 'black')
      end

      if Input.key_down?(K_SPACE)
        fill(color: 'white')
        draw_font(string: '右のLEDを光らせる', color: 'black')

        smalrubot.turn_on_right_led

        sleep(1)

        smalrubot.turn_off_right_led

        fill(color: 'white')
        draw_font(string: '左のLEDを光らせる', color: 'black')

        smalrubot.turn_on_left_led

        sleep(1)

        smalrubot.turn_off_left_led

        fill(color: 'white')
      end

      if Input.key_down?(K_H)
        until !Input.key_down?(K_H)
          fill(color: 'white')
          msg = 'センサーの情報: ' +
            "左 #{smalrubot.left_sensor_value} " +
            "右 #{smalrubot.right_sensor_value}"
          draw_font(string: msg, color: 'black')
          await
        end
        fill(color: 'white')
      end
    end
  end

  stage1.on(:key_push, K_A) do
    threshold = 400

    loop do
      fill(color: 'white')
      draw_font(string: '自動運転', color: 'black')

      left_sensor = smalrubot.left_sensor_value < threshold
      right_sensor = smalrubot.right_sensor_value < threshold

      if !left_sensor && !right_sensor
        smalrubot.forward
      end

      loop do
        if left_sensor || right_sensor
          if left_sensor && right_sensor
            fill(color: 'white')
            draw_font(string: '前方障害物発見！', color: 'black')

            smalrubot.backward

            loop do
              left_sensor = smalrubot.left_sensor_value < threshold
              right_sensor = smalrubot.right_sensor_value < threshold
              if !left_sensor && !right_sensor
                smalrubot.stop
                break
              end
            end

            if rand(2) == 1
              smalrubot.turn_left(sec: 0.1)
            else
              smalrubot.turn_right(sec: 0.1)
            end
          else
            if right_sensor
              fill(color: 'white')
              draw_font(string: '右側障害物発見！', color: 'black')

              #smalrubot.backward(sec: 0.1)
              smalrubot.turn_left

              loop do
                left_sensor = smalrubot.left_sensor_value < threshold
                right_sensor = smalrubot.right_sensor_value < threshold
                if !left_sensor && !right_sensor
                  smalrubot.stop
                  break
                end
              end
            else
              if left_sensor
                fill(color: 'white')
                draw_font(string: '左側障害物発見！', color: 'black')

                #smalrubot.backward(sec: 0.1)
                smalrubot.turn_right

                loop do
                  left_sensor = smalrubot.left_sensor_value < threshold
                  right_sensor = smalrubot.right_sensor_value < threshold
                  if !left_sensor && !right_sensor
                    smalrubot.stop
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

        left_sensor = smalrubot.left_sensor_value < threshold
        right_sensor = smalrubot.right_sensor_value < threshold
      end

      if Input.key_down?(K_Y)
        fill(color: 'white')
        smalrubot.stop
        break
      end
    end
  end
end
