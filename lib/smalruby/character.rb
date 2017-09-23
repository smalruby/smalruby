# -*- coding: utf-8 -*-
require 'forwardable'
require 'mutex_m'
require_relative 'cordinate_system'

module Smalruby
  # キャラクターを表現するクラス
  class Character
    extend Forwardable

    cattr_accessor :font_cache
    self.font_cache = {}
    font_cache.extend(Mutex_m)

    cattr_accessor :sound_cache
    self.sound_cache = {}
    sound_cache.extend(Mutex_m)

    cattr_accessor :hardware_cache
    self.hardware_cache = {}
    hardware_cache.extend(Mutex_m)

    attr_accessor :event_handlers
    attr_accessor :threads
    attr_accessor :checking_hit_targets
    attr_accessor :costumes
    attr_accessor :costume_index
    attr_reader :rotation_style
    attr_reader :enable_pen
    attr_accessor :pen_color
    attr_accessor :volume
    attr_reader :sprite

    def_instance_delegators(
      :@position,
      :x,
      :y
    )

    def_instance_delegators(
      :@sprite,
      :===,
      :target,
      :check,
      :vanished?,
      :collision,
      :collision=,
      :z,
      :alpha,
      :image,
      :scale_x,
      :scale_y,
      :center_x,
      :center_y,
      :blend,
      :shader,
      :collision_enable,
      :collision_sync,
      :visible,
      :image=,
      :vanish,
      :z=,
      :scale_x=,
      :scale_y=,
      :center_x=,
      :center_y=,
      :alpha=,
      :blend=,
      :shader=,
      :target=,
      :collision_enable=,
      :collision_sync=,
    )

    def initialize(option = {})
      defaults = {
        x: 0,
        y: 0,
        costume: nil,
        costume_index: 0,
        angle: CordinateSystem.right_angle,
        visible: true,
        rotation_style: :free
      }
      opt = process_optional_arguments(option, defaults)

      @costume_name__index = {}
      @costumes = Array.wrap(opt[:costume]).compact.map.with_index { |costume, i|
        if costume.is_a?(String)
          md = /^(?:([^:]+):)?(.*)$/.match(costume)
          name = md[1]
          path = md[2]
          costume = Image.load(asset_path(path))
        end
        name ||= "costume#{i + 1}"
        @costume_name__index[name] = i
        costume
      }
      @costume_index = opt[:costume_index]

      @sprite = Sprite.new(0, 0, @costumes[@costume_index])
      @position = CordinateSystem.new(self, opt[:x], opt[:y])
      @sprite.x, @sprite.y = *@position.dxruby_xy

      @event_handlers = {}
      @threads = []
      @checking_hit_targets = []
      @sprite.angle = 0
      @enable_pen = false
      @pen_color = 'black'
      @volume = 100

      self.scale_x = 1.0
      self.scale_y = 1.0
      @vector = { x: 1, y: 0 }

      [:visible].each do |k|
        if opt.key?(k)
          send("#{k}=", opt[k])
        end
      end

      self.rotation_style = opt[:rotation_style]

      self.angle = opt[:angle] if opt[:angle] != CordinateSystem.right_angle

      # HACK: Windows XP SP3の環境でワーカースレッドで音声を読み込めな
      # い不具合が発生した。このためメインスレッドでプリロードしておく。
      %w(do re mi fa so ra si do_2).each do |n|
        new_sound("piano_#{n}.wav")
      end

      World.instance.objects << self
    end

    # @!group 動き

    # (  )歩動かす
    def move(val = 1)
      self.position = [x + @vector[:x] * val * CordinateSystem.vector[:x], y + @vector[:y] * val * CordinateSystem.vector[:y]]
    end

    # (  )歩後ろに動かす
    def move_back(val = 1)
      move(-val)
    end

    # X座標を(  )にする
    def x=(val)
      left = @sprite.x + center_x
      top = @sprite.y + center_y

      @position.x = val
      @sprite.x = @position.dxruby_x

      draw_pen(left, top, @sprite.x + center_x, @sprite.y + center_y) if @enable_pen
    end

    # Y座標を(  )にする
    def y=(val)
      left = @sprite.x + center_x
      top = @sprite.y + center_y

      @position.y = val
      @sprite.y = @position.dxruby_y

      draw_pen(left, top, @sprite.x + center_x, @sprite.y + center_y) if @enable_pen
    end

    # X座標を(  )、Y座標を(  )にする
    def position=(val)
      @position.x, @position.y = *val

      if @enable_pen
        @enable_pen = false
        left = @sprite.x + center_x
        top = @sprite.y + center_y
        @sprite.x, @sprite.y = *@position.dxruby_xy
        draw_pen(left, top, @sprite.x + center_x, @sprite.y + center_y)
        @enable_pen = true
      else
        @sprite.x, @sprite.y = *@position.dxruby_xy
      end
    end

    # X座標、Y座標
    def position
      @position.to_a
    end

    # くるっと振り返る
    def bounce
      sync_angle(@vector[:x] * -1, @vector[:y] * -1)
    end
    alias turn bounce

    # 横に振り返る
    def bounce_x
      sync_angle(@vector[:x] * -1, @vector[:y])
    end
    alias turn_x bounce_x

    # 縦に振り返る
    def bounce_y
      sync_angle(@vector[:x], @vector[:y] * -1)
    end
    alias turn_y bounce_y

    # もし端に着いたら、跳ね返る
    def if_on_edge_bounce
      lr = on_left_or_right_edge?
      tb = on_top_or_bottom_edge?
      if lr && tb
        bounce
      elsif lr
        bounce_x
      elsif tb
        bounce_y
      end
    end
    alias turn_if_reach_wall if_on_edge_bounce

    def turn_clockwise(angle)
      self.angle += angle
    end
    alias turn_cw turn_clockwise
    alias rotate turn_clockwise

    def turn_counterclockwise(angle)
      self.angle -= angle
    end
    alias turn_ccw turn_counterclockwise

    def rotation_style=(val)
      @rotation_style = val
      sync_angle(@vector[:x], @vector[:y])
    end

    # 角度
    def angle
      val = if @rotation_style == :free
              @sprite.angle
            else
              x, y = @vector[:x], @vector[:y]
              a = Math.acos(x / Math.sqrt(x**2 + y**2)) * 180 / Math::PI
              a = 360 - a if y < 0
              a
            end
      (val + CordinateSystem.right_angle).round % 360
    end

    # (　)度に向ける
    def angle=(val)
      set_angle_without_adjust(val- CordinateSystem.right_angle)
    end

    # (  )に向ける
    def point_towards(target)
      if target == :mouse
        tx, ty = *Mouse.position
      else
        tx = target.x
        ty = target.y
      end
      dx = tx - x
      dy = ty - y
      self.angle = Math.atan2(dy, dx) * 180 / Math::PI
    end

    # (  )に行く
    def go_to(target)
      if target == :mouse
        x, y = *Mouse.position
        x -= @position.center_x
        y -= @position.center_y
      else
        x = target.x
        y = target.y
      end
      self.position = [x, y]
    end

    # @!endgroup

    # @!group 見た目

    def say(options = {})
      defaults = {
        message: '',
        second: 0,
      }
      opts = process_optional_arguments(options, defaults)

      message = opts[:message].to_s
      return if message == @current_message

      @current_message = message

      if @balloon
        @balloon.vanish
        @balloon = nil
      end

      return if message.empty?

      lines = message.to_s.lines.map { |l| l.scan(/.{1,10}/) }.flatten
      font = new_font(16)
      width = lines.map { |l| font.get_width(l) }.max
      height = lines.length * (font.size + 1)
      frame_size = 3
      margin_size = 3
      image = Image.new(width + (frame_size + margin_size) * 2,
                        height + (frame_size + margin_size) * 2)
      image.box_fill(0,
                     0,
                     width + (frame_size + margin_size) * 2 - 1,
                     height + (frame_size + margin_size) * 2 - 1,
                     [125, 125, 125])
      image.box_fill(frame_size,
                     frame_size,
                     width + (frame_size + margin_size) + margin_size - 1,
                     height + (frame_size + margin_size) + margin_size - 1,
                     [255, 255, 255])
      lines.each.with_index do |line, row|
        image.draw_font(frame_size + margin_size,
                        frame_size + margin_size + (font.size + 1) * row,
                        line, font, [0, 0, 0])
      end
      @balloon = Sprite.new(@position.dxruby_x, @position.dxruby_y, image)

      if opts[:second] > 0
        sleep(opts[:second])
        @current_message = ''
        @balloon.vanish
        @balloon = nil
      end
    end

    # 表示する/隠す
    def visible=(val)
      if val
        self.collision_enable = true
      else
        self.collision_enable = false
      end
      @sprite.visible = val
    end

    # 次のコスチュームにする
    def next_costume
      self.costume_index = @costume_index + 1
    end

    # コスチュームを(  )にする
    def switch_costume(name)
      if @costume_name__index.key?(name)
        index = @costume_name__index[name]
      else
        index = 0
      end
      self.costume_index = index
    end

    def costume_index=(val)
      @costume_index = val % @costumes.length
      self.image = @costumes[@costume_index]
    end

    # @!endgroup

    # @!group 調べる

    # 距離
    def distance(x, y)
      Math.sqrt((self.x + @position.center_x - x).abs**2 +
                (self.y + @position.center_y - y).abs**2).to_i
    end

    # 端に着いた?
    def touching_edge?
      on_left_or_right_edge? || on_top_or_bottom_edge?
    end
    alias reach_wall? touching_edge?

    # 左右の端に着いた?
    def on_left_or_right_edge?
      @position.min_x <= CordinateSystem.min_x || @position.max_x >= CordinateSystem.max_x
    end
    alias reach_left_or_right_wall? on_left_or_right_edge?

    # 上下の端に着いた?
    def on_top_or_bottom_edge?
      @position.min_y <= CordinateSystem.min_y || @position.max_y >= CordinateSystem.max_y
    end
    alias reach_top_or_bottom_wall? on_top_or_bottom_edge?

    def hit?(other)
      check([other]).length > 0
    end

    # @!endgroup

    # @!group 音

    # (  )の音を鳴らす
    def play(option = {})
      defaults = {
        name: 'piano_do.wav'
      }
      opt = process_optional_arguments(option, defaults)

      sound = new_sound(opt[:name])
      sound.set_volume(calc_volume)
      sound.play
    end

    # @!endgroup

    # @!group ペン

    def stamp
      stage_image = world.current_stage.image
      render_target = RenderTarget.new(Window.width, Window.height, Color.smalruby_to_dxruby(:black))
      render_target.draw(0, 0, stage_image)
      begin
        @sprite.target = render_target
        @sprite.draw
      ensure
        @sprite.target = nil
      end
      stage_image.draw(0, 0, render_target.to_image)
    end

    # Clears all pen marks from the Stage
    def clear
      world.current_stage.clear
    end

    # ペンを下ろす
    def pen_down
      @enable_pen = true
    end
    alias down_pen pen_down

    # ペンを上げる
    def pen_up
      @enable_pen = false
    end
    alias up_pen pen_up

    # set pen color
    #
    # @param [Array<Integer>|Symbol|Integer] val color
    #   When color is Array<Integer>, it means [R, G, B].
    #   When color is Symbol, it means the color code; like :white, :black, etc...
    #   When color is Integer, it means hue.
    def set_pen_color_to(val)
      if val.is_a?(Numeric)
        val %= 201
        _, s, l = Color.rgb_to_hsl(*pen_color)
        val = Color.hsl_to_rgb(val, s, l)
      end
      @pen_color = val
    end
    alias pen_color= set_pen_color_to

    # change pen color
    #
    # @param [Integer] val color
    def change_pen_color_by(val)
      h, s, l = Color.rgb_to_hsl(*pen_color)
      @pen_color = Color.hsl_to_rgb(h + val, s, l)
    end

    # set pen shade
    #
    # @param Integer val shade
    def pen_shade=(val)
      val %= 101
      h, s, = *Color.rgb_to_hsl(*pen_color)
      @pen_color = Color.hsl_to_rgb(h, s, val)
    end

    # @!endgroup

    # @!group ハードウェア

    # LED
    def led(pin)
      Hardware.create_hardware(Hardware::Led, pin)
    end

    # RGB LED(アノード)
    def rgb_led_anode(pin)
      Hardware.create_hardware(Hardware::RgbLedAnode, pin)
    end

    # RGB LED(カソード)
    def rgb_led_cathode(pin)
      Hardware.create_hardware(Hardware::RgbLedCathode, pin)
    end

    # マイコン内蔵RGB LED
    def neo_pixel(pin)
      Hardware.create_hardware(Hardware::NeoPixel, pin)
    end

    # サーボモーター
    def servo(pin)
      Hardware.create_hardware(Hardware::Servo, pin)
    end

    # 2WD車
    def two_wheel_drive_car(pin)
      Hardware.create_hardware(Hardware::TwoWheelDriveCar, pin)
    end

    # モータードライバ
    def motor_driver(pin)
      Hardware.create_hardware(Hardware::MotorDriver, pin)
    end

    # ボタン
    def button(pin)
      Hardware.create_hardware(Hardware::Button, pin)
    end

    # 汎用的なセンサー
    def sensor(pin)
      Hardware.create_hardware(Hardware::Sensor, pin)
    end

    # create or get Hardware::SmalrubotV3 instance
    def smalrubot_v3
      Hardware.create_hardware(Hardware::SmalrubotV3)
    end

    # create or get Hardware::SmalrubotS1 instance
    def smalrubot_s1
      Hardware.create_hardware(Hardware::SmalrubotS1)
    end

    # @!endgroup

    def draw
      draw_balloon if visible

      @sprite.draw
    end

    def when(event, *options, &block)
      event, options = *normalize_event(event, options)

      @event_handlers[event] ||= []
      h = EventHandler.new(self, options, &block)
      @event_handlers[event] << h

      case event
      when :green_flag_clicked
        @threads << h.call if Smalruby.started?
      when :hit
        @checking_hit_targets << options
        @checking_hit_targets.flatten!
        @checking_hit_targets.uniq!
      end
    end
    alias :on :when

    def start
      @event_handlers[:green_flag_clicked].try(:each) do |h|
        @threads << h.call
      end
    end

    def key_pressed(keys)
      @event_handlers[:key_pressed].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |k| keys.include?(k) }
          next
        end
        @threads << h.call
      end
    end
    alias key_down key_pressed

    def key_push(keys)
      @event_handlers[:key_push].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |k| keys.include?(k) }
          next
        end
        @threads << h.call
      end
    end

    def click(buttons, mouse_position)
      @event_handlers[:click].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |b| buttons.include?(b) }
          next
        end
        @threads << h.call(*mouse_position)
      end
    end

    def hit
      # TODO: なんでもいいからキャラクターに当たった場合に対応する
      @checking_hit_targets &= World.instance.objects
      objects = check(@checking_hit_targets)
      return if objects.empty?
      @event_handlers[:hit].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |o| objects.include?(o) }
          next
        end
        @threads << h.call(h.options & objects)
      end
    end

    def when_receive(message)
      @event_handlers[:receive].try(:each) do |h|
        if h.options.length > 0 && !h.options.include?(message)
          next
        end
        @threads << h.call
      end
    end

    def alive?
      @threads.compact!
      @threads.delete_if { |t|
        if t.alive?
          false
        else
          begin
            t.join
          rescue => e
            Util.print_exception(e)
            exit(1)
          end
          true
        end
      }
      @threads.length > 0
    end

    def join
      @threads.compact!
      @threads.each(&:join)
    end

    def forever
      Kernel.loop do
        yield
        Smalruby.await
      end
    end
    alias loop forever

    # 1フレーム待つ
    def await
      Smalruby.await
    end

    def broadcast(message)
      world.messages.push(message)
    end

    private

    def draw_pen(left, top, right, bottom)
      return if Util.raspberrypi? || !visible || vanished?
      world.current_stage.line(left: left, top: top,
                               right: right, bottom: bottom,
                               color: @pen_color)
    end

    def sync_angle(x, y)
      a = Math.acos(x / Math.sqrt(x**2 + y**2)) * 180 / Math::PI
      a = 360 - a if y < 0

      set_angle_without_adjust(a)
    end

    def set_angle_without_adjust(val)
      val %= 360
      radian = val * Math::PI / 180
      @vector[:x] = Math.cos(radian).round(3)
      @vector[:y] = Math.sin(radian).round(3)

      if @rotation_style == :free
        self.scale_x = scale_x.abs
        @sprite.angle = val
      elsif @rotation_style == :left_right
        if @vector[:x] >= 0
          self.scale_x = scale_x.abs * -1
        else
          self.scale_x = scale_x.abs
        end
        @sprite.angle = 0
      else
        self.scale_x = scale_x.abs
        @sprite.angle = 0
      end
      if debug_mode?
        puts("angle: #{angle}, @sprite.angle: #{@sprite.angle}, vector: #{@vector}")
      end
    end

    def normalize_event(event, options)
      event = normalize_event_name(event)
      options = normalize_event_options(event, options)
      [event, options]
    end

    def normalize_event_name(event)
      event = event.to_sym
      case event
      when :start, :green_flag_clicked, :gf_clicked, :run_button_clicked, :rb_clicked
        :green_flag_clicked
      when :key_down, :key_pressed
        :key_pressed
      else
        event
      end
    end

    def normalize_event_options(event, options)
      case event
      when :key_pressed, :key_push
        options.map { |key|
          case key
          when String, Symbol
            self.class.const_get("K_#{key.to_s.upcase}")
          else
            key
          end
        }
      else
        options
      end
    end

    def asset_path(name)
      program_path = Pathname($PROGRAM_NAME).expand_path(Dir.pwd)
      paths = [Pathname("../#{name}").expand_path(program_path),
               Pathname("../__assets__/#{name}").expand_path(program_path),
               Pathname("../../../assets/#{name}").expand_path(__FILE__)]
      paths.find { |path| path.file? }.to_s
    end

    def new_font(size)
      self.class.font_cache.synchronize do
        self.class.font_cache[size] ||= Font.new(size)
      end
      self.class.font_cache[size]
    end

    def new_sound(name)
      self.class.sound_cache.synchronize do
        self.class.sound_cache[name] ||= Sound.new(asset_path(name))
      end
      self.class.sound_cache[name]
    end

    def draw_balloon
      if @balloon
        @balloon.x = @position.dxruby_x + image.width / 2
        if @balloon.x < 0
          @balloon.x = 0
        elsif @balloon.x + @balloon.image.width >= Window.width
          @balloon.x = Window.width - @balloon.image.width
        end
        @balloon.y = @position.dxruby_y - @balloon.image.height
        if @balloon.y < 0
          @balloon.y = 0
        elsif @balloon.y + @balloon.image.height > Window.height
          @balloon.y = Window.height - @balloon.image.height
        end
        @balloon.draw
      end
    end

    def process_optional_arguments(options, defaults)
      unknown_keys = options.keys - defaults.keys
      if unknown_keys.length > 0
        s = unknown_keys.map { |k| "#{k}: #{options[k].inspect}" }.join(', ')
        fail ArgumentError, "Unknown options: #{s}"
      end
      defaults.merge(options)
    end

    def print_exception(exception)
      $stderr.puts("#{exception.class}: #{exception.message}")
      $stderr.puts("        #{exception.backtrace.join("\n        ")}")
    end

    private

    def calc_volume
      (255 * @volume / 100.0).to_i
    end
  end
end
