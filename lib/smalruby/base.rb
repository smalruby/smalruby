# -*- coding: utf-8 -*-
require 'forwardable'

module Smalruby
  # 操作対象のベースクラス
  class Base < Sprite
    extend Forwardable

    attr_accessor :event_handlers
    attr_accessor :threads

    def initialize(x, y, image = nil)
      super(x, y, image)

      @event_handlers = {}
      @threads = []

      @scale_x = 1.0
      @scale_y = 1.0
      @vector = { x: 1, y: 0 }

      World.instance.objects << self
    end

    # @!group 動き

    def move(val = 1)
      @x += @vector[:x] * val
      @y += @vector[:y] * val
    end

    def turn
      @vector[:x] *= -1
      @vector[:y] *= -1
      @scale_x *= -1
    end

    def turn_if_reach_wall
      max_width = Window.width - @image.width
      if @x < 0
        @x = 0
        turn
      elsif @x >= max_width
        @x = max_width - 1
        turn
      end
    end

    # @!endgroup

    def on(event, *args, &block)
      event = event.to_sym
      @event_handlers[event] ||= []
      h = EventHandler.new(self, args, &block)
      @event_handlers[event] << h

      if Smalruby.started?
        @threads << h.call
      end
    end

    def start
      @event_handlers[:start].try(:each) do |h|
        @threads << h.call
      end
    end

    def click
      @event_handlers[:click].try(:each) do |h|
        @threads << h.call
      end
    end

    def alive?
      return @threads.any?(&:alive?)
    end

    def join
      @threads.each(&:join)
    end

    def loop(&block)
      while true
        yield
        Smalruby.await
      end
    end

    private

    def asset_path(name)
      return File.expand_path("../../../assets/#{name}", __FILE__)
    end
  end
end
