# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # Smalrubot on Studuino v1 class
    class SmalrubotS1
      include Smalrubot::Board::Studuino

      # default dc motor power ratio
      DEFAULT_DC_MOTOR_POWER_RATIO = 50

      def initialize(_)
        world.board.init_dc_motor_port(PORT_M1, 0)
        world.board.init_dc_motor_port(PORT_M2, 0)

        world.board.init_sensor_port(PORT_A0, PIDLED)
        world.board.init_sensor_port(PORT_A1, PIDLED)

        world.board.init_sensor_port(PORT_A4, PIDIRPHOTOREFLECTOR)
        world.board.init_sensor_port(PORT_A5, PIDIRPHOTOREFLECTOR)

        @dc_motor_power_ratios = {
          PORT_M1 => DEFAULT_DC_MOTOR_POWER_RATIO,
          PORT_M2 => DEFAULT_DC_MOTOR_POWER_RATIO,
        }
      end

      def left_dc_motor_power_ratio
        @dc_motor_power_ratios[PORT_M1]
      end

      def left_dc_motor_power_ratio=(val)
        set_dc_motor_power_ratio(PORT_M1, val)
      end

      def right_dc_motor_power_ratio
        @dc_motor_power_ratios[PORT_M2]
      end

      def right_dc_motor_power_ratio=(val)
        set_dc_motor_power_ratio(PORT_M2, val)
      end

      # @!method forward(sec: nil)
      #   forward
      #
      #   @param [Float] time of forwarding

      # @!method backward(sec: nil)
      #   backward
      #
      #   @param [Float] time of backwarding

      # @!method turn_left(sec: nil)
      #   turn left
      #
      #   @param [Float] time of turning left

      # @!method turn_right(sec: nil)
      #   turn right
      #
      #   @param [Float] time of turning right

      # @!method stop(sec: nil)
      #   stop
      #
      #   @param [Float] time of stopping
      %i(forward backward turn_left turn_right stop).each do |direction|
        define_method(direction) do |sec: nil|
          run(direction, sec: sec)
        end
      end

      def left_sensor_value
        world.board.get_ir_photoreflector_value(PORT_A4).to_i
      end

      def right_sensor_value
        world.board.get_ir_photoreflector_value(PORT_A5).to_i
      end

      def turn_on_blue_led
        world.board.led(PORT_A0, ON)
      end
      alias_method :turn_on_left_led, :turn_on_blue_led

      def turn_off_blue_led
        world.board.led(PORT_A0, OFF)
      end
      alias_method :turn_off_left_led, :turn_off_blue_led

      def turn_on_red_led
        world.board.led(PORT_A1, ON)
      end
      alias_method :turn_on_right_led, :turn_on_red_led

      def turn_off_red_led
        world.board.led(PORT_A1, OFF)
      end
      alias_method :turn_off_right_led, :turn_off_red_led

      private

      def set_dc_motor_power_ratio(port, val)
        if val < 0
          @dc_motor_power_ratios[port] = 0
        elsif val > 100
          @dc_motor_power_ratios[port] = 100
        else
          @dc_motor_power_ratios[port] = val
        end
        set_dc_motor_power(port)
      end

      def set_dc_motor_power(port)
        ratio = @dc_motor_power_ratios[port]
        power = Smalrubot::Board::HIGH * (ratio.to_f / 100)
        world.board.dc_motor_power(port, power.round)
      end

      def set_dc_motor_powers
        @dc_motor_power_ratios.keys.each do |port|
          set_dc_motor_power(port)
        end
      end

      def run(direction, sec: nil)
        case direction
        when :forward
          set_dc_motor_powers
          world.board.dc_motor_control(PORT_M1, NORMAL)
          world.board.dc_motor_control(PORT_M2, NORMAL)
        when :backward
          set_dc_motor_powers
          world.board.dc_motor_control(PORT_M1, REVERSE)
          world.board.dc_motor_control(PORT_M2, REVERSE)
        when :turn_left
          set_dc_motor_powers
          world.board.dc_motor_control(PORT_M1, REVERSE)
          world.board.dc_motor_control(PORT_M2, NORMAL)
        when :turn_right
          set_dc_motor_powers
          world.board.dc_motor_control(PORT_M1, NORMAL)
          world.board.dc_motor_control(PORT_M2, REVERSE)
        when :stop
          _stop
        end

        if (sec = sec.to_f) > 0
          sleep(sec)
          if direction != :stop
            _stop
          end
        end
      end

      def _stop
        set_dc_motor_powers
        world.board.dc_motor_control(PORT_M1, COAST)
        world.board.dc_motor_control(PORT_M2, COAST)
      end
    end
  end
end
