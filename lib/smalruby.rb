# -*- coding: utf-8 -*-
require 'smalruby/version'
require 'active_support/all'
require 'active_support/concurrency/latch'
require 'dxruby'

require 'smalruby/world'
require 'smalruby/base'
require 'smalruby/event_handler'

module Smalruby
  extend ActiveSupport::Autoload

  autoload :Console
  autoload :Car

  module_function

  @@started = false
  @@lock = ActiveSupport::Concurrency::Latch.new(1)
  @@draw_sprites = []

  def draw(sprite)
    Smalruby.lock.await
    @@draw_sprites << sprite
  end

  def start
    @@started = true
    begin
      if world.objects.any? { |o| /console/i !~ o.class.name }
        # ウィンドウアプリケーション
        Window.caption = File.basename($0)
        first = true
        Window.fps = 30
        Window.loop do
          lock do
            if first
              world.objects.each do |object|
                object.start
              end
              first = false
            end
            if Input.key_down?(K_ESCAPE)
              exit
            end
            world.objects.delete_if { |o|
              if o.alive?
                false
              else
                o.join
                true
              end
            }
            world.objects.each do |o|
              if o.respond_to?(:draw)
                o.draw
              end
            end
          end
        end
      else
        # コンソールアプリケーション
        world.objects.each do |object|
          object.start
        end
        world.objects.each(&:join)
      end
    rescue SystemExit
    end
  end

  def started?
    return @@started
  end

  def world
    World.instance
  end

  @@draw_mutex = Mutex.new
  @@draw_cv = ConditionVariable.new

  def lock(&block)
    @@draw_mutex.synchronize do
      yield
      @@draw_cv.broadcast
    end
  end

  def await
    @@draw_mutex.synchronize do
      @@draw_cv.wait(@@draw_mutex)
    end
  end
end

include Smalruby

END {
  if !started?
    start
  end
}
