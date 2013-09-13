# -*- coding: utf-8 -*-
require 'forwardable'

module Smalruby
  # 操作対象のベースクラス
  class Base
    extend Forwardable

    attr_accessor :event_handlers
    attr_accessor :threads

    def initialize
      World.instance.objects << self
      @event_handlers = {}
      @threads = []
    end

    def on(event, *args, &block)
      event = event.to_sym
      @event_handlers[event] ||= []
      @event_handlers[event] << EventHandler.new(self, args, &block)
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
  end
end
