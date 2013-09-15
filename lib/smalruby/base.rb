# -*- coding: utf-8 -*-
require 'forwardable'

module Smalruby
  # 操作対象のベースクラス
  class Base
    extend Forwardable

    attr_accessor :event_handlers
    attr_accessor :threads

    def initialize
      @event_handlers = {}
      @threads = []

      World.instance.objects << self
    end

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
