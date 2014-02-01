# -*- coding: utf-8 -*-
require 'smalruby/version'
require 'active_support/all'
require 'dxruby'
require 'English'
require 'pathname'

require 'smalruby/util'
require 'smalruby/world'
require 'smalruby/color'
require 'smalruby/character'
require 'smalruby/event_handler'

module Smalruby
  extend ActiveSupport::Autoload

  autoload :Console
  autoload :Canvas
  autoload :Scene
  autoload :Hardware

  module_function

  def start
    @started = true
    begin
      if world.objects.any? { |o| /console/i !~ o.class.name }
        start_window_application
      else
        start_console_application
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

  def init_hardware(options = {})
    Hardware.init(options)
  end

  private

  @started = false
  @draw_mutex = Mutex.new
  @draw_cv = ConditionVariable.new

  class << self
    private

    def init_window_application
      Window.caption = File.basename($PROGRAM_NAME)
      Window.fps = 15

      # HACK: DXRubyのためのサウンド関係の初期化処理。こうしておかな
      # いとDirectSoundの初期化でエラーが発生する
      begin
        Sound.new('')
      rescue
      end
    end

    def start_window_application
      init_window_application

      first = true
      Window.loop do
        lock do
          if Input.key_down?(K_ESCAPE)
            exit
          end

          if first
            world.objects.each do |object|
              object.start
            end
            first = false
          end

          mouse_down_and_push

          key_down_and_push

          hit

          sensor_change

          world.objects.delete_if do |o|
            if !o.alive?
              o.join
            end
            o.vanished?
          end

          Sprite.draw(world.objects)
        end
      end
    end

    def start_console_application
      world.objects.each do |object|
        object.start
      end
      world.objects.each(&:join)
    end

    def lock(&block)
      @draw_mutex.synchronize do
        yield
        @draw_cv.broadcast
      end
    end

    def mouse_down_and_push
      clickable_objects = world.objects.select { |o| o.respond_to?(:click) }
      if clickable_objects.length > 0 &&
          (Input.mouse_push?(M_LBUTTON) || Input.mouse_push?(M_RBUTTON) ||
           Input.mouse_push?(M_MBUTTON))
        buttons = []
        {
          left: M_LBUTTON,
          right: M_RBUTTON,
          center: M_MBUTTON,
        }.each do |sym, const|
          if Input.mouse_down?(const)
            buttons << sym
          end
        end
        s = Sprite.new(Input.mouse_pos_x, Input.mouse_pos_y)
        s.collision = [0, 0, 1, 1]
        s.check(clickable_objects).each do |o|
          o.click(buttons)
        end
      end
    end

    def key_down_and_push
      if (keys = Input.keys).length > 0
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

    def hit
      world.objects.each do |o|
        if o.respond_to?(:hit)
          o.hit
        end
      end
    end

    def sensor_change
      if world.sensor_change_queue.length > 0
        sensor_change_queue = nil
        world.sensor_change_queue.synchronize do
          sensor_change_queue = world.sensor_change_queue.dup
          world.sensor_change_queue.clear
        end

        world.objects.each do |o|
          if o.respond_to?(:sensor_change)
            sensor_change_queue.each do |pin, value|
              o.sensor_change(pin, value)
            end
          end
        end
      end
    end
  end
end

include Smalruby

at_exit do
  Smalruby.start if !$ERROR_INFO && !Smalruby.started?
end
