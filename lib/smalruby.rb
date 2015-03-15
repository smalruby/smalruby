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
  autoload :Stage
  autoload :Hardware

  module_function

  def start
    @started = true
    begin
      if world.objects.any? { |o| /console/i !~ o.class.name }
        begin
          start_window_application
        ensure
          Hardware.stop
        end
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
    if Thread.current == Thread.main
      sleep(1.0 / 15)
    else
      @draw_mutex.synchronize do
        @draw_cv.wait(@draw_mutex)
      end
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
      Window.bgcolor = [255, 255, 255]

      # HACK: DXRubyのためのサウンド関係の初期化処理。こうしておかな
      # いとDirectSoundの初期化でエラーが発生する
      begin
        Sound.new('')
      rescue
      end

      activate_window
    end

    def activate_window
      if Util.windows?
        require 'Win32API'

        # http://f.orzando.net/pukiwiki-plus/index.php?Programming%2FTips
        # を参考にした
        hwnd_active =
          Win32API.new('user32', 'GetForegroundWindow', nil, 'i').call
        this_thread_id =
          Win32API.new('Kernel32', 'GetCurrentThreadId', nil, 'i').call
        active_thread_id =
          Win32API.new('user32', 'GetWindowThreadProcessId', %w(i p), 'i')
          .call(hwnd_active, 0)
        attach_thread_input =
          Win32API.new('user32', 'AttachThreadInput', %w(i i i), 'v')
        attach_thread_input.call(this_thread_id, active_thread_id, 1)
        Win32API.new('user32', 'SetForegroundWindow', %w(i), 'i')
          .call(Window.hWnd)
        attach_thread_input.call(this_thread_id, active_thread_id, 0)

        hwnd_topmost = -1
        swp_nosize = 0x0001
        swp_nomove = 0x0002
        Win32API.new('user32', 'SetWindowPos', %w(i i i i i i i), 'i')
          .call(Window.hWnd, hwnd_topmost, 0, 0, 0, 0, swp_nosize | swp_nomove)
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
            unless world.objects.any? { |o| o.is_a?(Stage) }
              Stage.new(color: 'white') unless Util.raspberrypi?
            end
            if Hardware.failed?
              canvas = Canvas.new(height: 32)
              canvas.draw_font(string: 'ハードウェアの準備に失敗しました',
                               color: 'red')
            end
            world.objects.each do |object|
              object.start
            end
            first = false
          end

          mouse_down_and_push

          key_down_and_push

          hit

          world.objects.delete_if do |o|
            o.join unless o.alive?
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

    def lock
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
          center: M_MBUTTON
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
  end
end

include Smalruby

if Util.windows? || ENV['SMALRUBY_WINDOWED']
  Window.windowed = true
else
  Window.windowed = false
end

at_exit do
  Smalruby.start if !$ERROR_INFO && !Smalruby.started?
end
