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
  autoload :Canvas

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
        Window.fps = 15
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
            if Input.mouse_push?(M_LBUTTON) || Input.mouse_push?(M_RBUTTON) ||
                Input.mouse_push?(M_MBUTTON)
              x, y = Input.mouse_pos_x, Input.mouse_pos_y
              s = Sprite.new(x, y)
              s.collision = [0, 0, 1, 1]
              buttons = []
              if Input.mouse_down?(M_LBUTTON)
                buttons << :left
              end
              if Input.mouse_down?(M_RBUTTON)
                buttons << :right
              end
              if Input.mouse_down?(M_MBUTTON)
                buttons << :center
              end
              s.check(world.objects).each do |o|
                if o.respond_to?(:click)
                  o.click(buttons)
                end
              end
            end
            world.objects.delete_if { |o|
              if !o.alive?
                o.join
              end
              o.vanished?
            }
            Sprite.draw(world.objects)
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
