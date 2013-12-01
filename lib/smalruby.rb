# -*- coding: utf-8 -*-
require 'smalruby/version'
require 'active_support/all'
require 'active_support/concurrency/latch'
require 'dxruby'

require 'smalruby/world'
require 'smalruby/color'
require 'smalruby/character'
require 'smalruby/event_handler'

module Smalruby
  extend ActiveSupport::Autoload

  autoload :Console
  autoload :Canvas

  module_function

  def start
    @started = true
    begin
      if world.objects.any? { |o| /console/i !~ o.class.name }
        # ウィンドウアプリケーション
        Window.caption = File.basename($PROGRAM_NAME)
        first = true
        Window.fps = 15

        # サウンド関係の初期化処理
        begin
          Sound.new('')
        rescue
        end

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
            if (keys = Input.keys).length > 0
              key_down_and_push(keys)
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
    return @started
  end

  def world
    return World.instance
  end

  def await
    @draw_mutex.synchronize do
      @draw_cv.wait(@draw_mutex)
    end
  end

  private

  @started = false
  @draw_mutex = Mutex.new
  @draw_cv = ConditionVariable.new

  class << self

    private

    def lock(&block)
      @draw_mutex.synchronize do
        yield
        @draw_cv.broadcast
      end
    end

    def key_down_and_push(keys)
      world.objects.each do |o|
        if o.respond_to?(:key_down)
          o.key_down(keys)
        end
      end
      pushed_keys = keys.select { |key| Input.key_push?(key) }
      if pushed_keys.length > 0
        world.objects.each do |o|
          if o.respond_to?(:key_push)
            o.key_push(pushed_keys)
          end
        end
      end
    end
  end
end

include Smalruby

at_exit do
  if !Smalruby.started?
    Smalruby.start
  end
end
