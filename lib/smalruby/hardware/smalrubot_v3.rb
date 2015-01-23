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

      # Left touch sensor that is connected D4
      attr_reader :left_touch_sensor

      # Right touch sensor that is connected D3
      attr_reader :right_touch_sensor

      # Light sensor that is connected A0
      attr_reader :light_sensor

      def initialize(_)
        @red_led = Led.new(pin: 'D13')
        @green_led = Led.new(pin: 'D2')

        @left_motor = MotorDriver.new(pin: 'D6')
        @left_motor.speed = 100
        @right_motor = MotorDriver.new(pin: 'D9')
        @right_motor.speed = 100

        @left_touch_sensor = Button.new(pin: 'D4')
        @right_touch_sensor = Button.new(pin: 'D3')

        @light_sensor = Sensor.new(pin: 'A0')

        @current_motor_direction = :stop
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
