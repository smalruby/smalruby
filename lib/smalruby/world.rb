# -*- coding: utf-8 -*-
require 'singleton'

module Smalruby
  # 環境を表現するクラス
  class World
    include Singleton

    attr_accessor :objects
    attr_accessor :board
    attr_accessor :current_stage
    attr_reader :sensor_change_queue
    attr_reader :button_change_queue

    def initialize
      @objects = []
      @board = nil
      @sensor_change_queue = []
      @sensor_change_queue.extend(Mutex_m)
      @button_change_queue = []
      @button_change_queue.extend(Mutex_m)
    end

    def sensor_changed(pin, value)
      @sensor_change_queue.synchronize do
        @sensor_change_queue.push([pin, value])
      end
    end

    def button_changed(pin, up_or_down)
      @button_change_queue.synchronize do
        @button_change_queue.push([pin, up_or_down])
      end
    end
  end
end
