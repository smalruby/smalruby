# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # Smalrubot v3 class
    class SmalrubotV3
      # wait time for next action
      WAIT_TIME = 0.01

      @mutex = Mutex.new

      class << self
        # lock for motor driver
        def lock(&block)
          @mutex.synchronize do
            yield
          end
        end

        # unlock for motor driver
        def unlock(&block)
          @mutex.unlock
          yield
        ensure
          @mutex.lock
        end
      end

      # Red LED that is connected D13
      attr_reader :red_led

      # Green LED that is connected D2
      attr_reader :green_led

      # Left Motor that is connected D6, D7, D8
      attr_reader :left_motor

      # Right Motor that is connected D9, D10, D11
      attr_reader :right_motor

      # Left sensor that is connected A0
      attr_reader :left_sensor

      # Right sensor that is connected A1
      attr_reader :right_sensor

      def initialize(_)
        @red_led = Led.new(pin: 'D13')
        @green_led = Led.new(pin: 'D2')

        @left_motor = MotorDriver.new(pin: 'D6')
        @left_motor.speed = 100
        @right_motor = MotorDriver.new(pin: 'D9')
        @right_motor.speed = 100

        @left_sensor = Sensor.new(pin: 'A0')
        @right_sensor = Sensor.new(pin: 'A1')

        @current_motor_direction = :stop
      end

      def left_dc_motor_power_ratio
        @left_motor.speed
      end

      def left_dc_motor_power_ratio=(val)
        @left_motor.speed = val
      end

      def right_dc_motor_power_ratio
        @right_motor.speed
      end

      def right_dc_motor_power_ratio=(val)
        @right_motor.speed = val
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
      %i(forward backward turn_left turn_right).each do |direction|
        define_method(direction) do |sec: nil|
          run(direction, sec: sec)
        end
      end

      # stop
      #
      # @param [Float] time of stopping
      def stop(sec: WAIT_TIME)
        self.class.lock do
          @left_motor.stop
          @right_motor.stop
          @current_motor_direction = :stop
          if (sec = sec.to_f) > 0
            sleep(sec)
          end
        end
      end

      def left_sensor_value
        @left_sensor.value.to_i
      end

      def right_sensor_value
        @right_sensor.value.to_i
      end

      def turn_on_green_led
        @green_led.turn_on
      end
      alias_method :turn_on_left_led, :turn_on_green_led

      def turn_off_green_led
        @green_led.turn_off
      end
      alias_method :turn_off_left_led, :turn_off_green_led

      def turn_on_red_led
        @red_led.turn_on
      end
      alias_method :turn_on_right_led, :turn_on_red_led

      def turn_off_red_led
        @red_led.turn_off
      end
      alias_method :turn_off_right_led, :turn_off_red_led

      private

      def run(direction, sec: nil)
        self.class.lock do
          if @current_motor_direction != :stop
            self.class.unlock do
              stop(sec: WAIT_TIME)
            end
          end
          case direction
          when :forward
            @left_motor.forward
            @right_motor.forward
          when :backward
            @left_motor.backward
            @right_motor.backward
          when :turn_left
            @left_motor.backward
            @right_motor.forward
          when :turn_right
            @left_motor.forward
            @right_motor.backward
          end
          @current_motor_direction = direction
          if (sec = sec.to_f) > 0
            sleep(sec)
            if direction != :stop
              self.class.unlock do
                stop
              end
            end
          end
        end
      end
    end
  end
end
