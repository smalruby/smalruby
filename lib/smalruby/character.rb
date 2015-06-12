# -*- coding: utf-8 -*-
require 'forwardable'
require 'mutex_m'

module Smalruby
  # キャラクターを表現するクラス
  class Character < Sprite
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

    def initialize(option = {})
      defaults = {
        x: 0,
        y: 0,
        costume: nil,
        costume_index: 0,
        angle: 0,
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
      super(opt[:x], opt[:y], @costumes[@costume_index])

      @event_handlers = {}
      @threads = []
      @checking_hit_targets = []
      @angle = 0 unless Util.windows?
      @enable_pen = false
      @pen_color = 'black'

      self.scale_x = 1.0
      self.scale_y = 1.0
      @vector = { x: 1, y: 0 }

      [:visible].each do |k|
        if opt.key?(k)
          send("#{k}=", opt[k])
        end
      end

      self.rotation_style = opt[:rotation_style]

      self.angle = opt[:angle] if opt[:angle] != 0

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
      self.position = [x + @vector[:x] * val, y + @vector[:y] * val]
    end

    # (  )歩後ろに動かす
    def move_back(val = 1)
      move(-val)
    end

    # X座標を(  )にする
    def x=(val)
      left = x + center_x
      top = y + center_y

      if val < 0
        val = 0
      elsif val + image.width >= Window.width
        val = Window.width - image.width
      end

      super(val)

      draw_pen(left, top, x + center_x, y + center_y) if @enable_pen
    end

    # Y座標を(  )にする
    def y=(val)
      left = x + center_x
      top = y + center_y

      if val < 0
        val = 0
      elsif val + image.height >= Window.height
        val = Window.height - image.height
      end
      super(val)

      draw_pen(left, top, x + center_x, y + center_y) if @enable_pen
    end

    # X座標を(  )、Y座標を(  )にする
    def position=(val)
      if @enable_pen
        @enable_pen = false
        left = x + center_x
        top = y + center_y
        self.x = val[0]
        self.y = val[1]
        draw_pen(left, top, x + center_x, y + center_y)
        @enable_pen = true
      else
        self.x = val[0]
        self.y = val[1]
      end
    end

    # X座標、Y座標
    def position
      [x, y]
    end

    # くるっと振り返る
    def turn
      sync_angle(@vector[:x] * -1, @vector[:y] * -1)
    end

    # 横に振り返る
    def turn_x
      sync_angle(@vector[:x] * -1, @vector[:y])
    end

    # 縦に振り返る
    def turn_y
      sync_angle(@vector[:x], @vector[:y] * -1)
    end

    # もし端に着いたら、跳ね返る
    def turn_if_reach_wall
      lr = reach_left_or_right_wall?
      tb = reach_top_or_bottom_wall?
      if lr && tb
        turn
      elsif lr
        turn_x
      elsif tb
        turn_y
      end
    end

    # (  )度回転する
    def rotate(angle)
      self.angle += angle
    end

    def rotation_style=(val)
      @rotation_style = val
      sync_angle(@vector[:x], @vector[:y])
    end

    # 角度
    def angle
      return super if @rotation_style == :free

      x, y = @vector[:x], @vector[:y]
      a = Math.acos(x / Math.sqrt(x**2 + y**2)) * 180 / Math::PI
      a = 360 - a if y < 0
      a
    end

    # (　)度に向ける
    def angle=(val)
      val %= 360
      radian = val * Math::PI / 180
      @vector[:x] = Math.cos(radian)
      @vector[:y] = Math.sin(radian)

      if @rotation_style == :free
        self.scale_x = 1
        super(val)
      elsif @rotation_style == :left_right
        if @vector[:x] >= 0
          self.scale_x = 1
        else
          self.scale_x = -1
        end
        super(0)
      else
        self.scale_x = 1
        super(0)
      end
    end

    # (  )に向ける
    def point_towards(target)
      if target == :mouse
        tx = Input.mouse_pos_x
        ty = Input.mouse_pos_y
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
        x = Input.mouse_pos_x - center_x
        y = Input.mouse_pos_y - center_y
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
      @balloon = Sprite.new(x, y, image)
    end

    # 表示する/隠す
    def visible=(val)
      if val
        self.collision_enable = true
      else
        self.collision_enable = false
      end
      super
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
      Math.sqrt((self.x + center_x - x).abs**2 +
                (self.y + center_y - y).abs**2).to_i
    end

    # 端に着いた?
    def reach_wall?
      reach_left_or_right_wall? || reach_top_or_bottom_wall?
    end

    # 左右の端に着いた?
    def reach_left_or_right_wall?
      x <= 0 || x >= (Window.width - image.width)
    end

    # 上下の端に着いた?
    def reach_top_or_bottom_wall?
      y <= 0 || y >= (Window.height - image.height)
    end

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

      new_sound(opt[:name]).play
    end

    # @!endgroup

    # @!group ペン

    # ペンを下ろす
    def down_pen
      @enable_pen = true
    end

    # ペンを上げる
    def up_pen
      @enable_pen = false
    end

    # @!method pen_color=(val)
    # ペンの色を（  ）にする

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

      super
    end

    def on(event, *options, &block)
      event = event.to_sym
      @event_handlers[event] ||= []
      h = EventHandler.new(self, options, &block)
      @event_handlers[event] << h

      case event
      when :start
        @threads << h.call if Smalruby.started?
      when :hit
        @checking_hit_targets << options
        @checking_hit_targets.flatten!
        @checking_hit_targets.uniq!
      end
    end

    def start
      @event_handlers[:start].try(:each) do |h|
        @threads << h.call
      end
    end

    def key_down(keys)
      @event_handlers[:key_down].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |k| keys.include?(k) }
          next
        end
        @threads << h.call
      end
    end

    def key_push(keys)
      @event_handlers[:key_push].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |k| keys.include?(k) }
          next
        end
        @threads << h.call
      end
    end

    def click(buttons)
      @event_handlers[:click].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |b| buttons.include?(b) }
          next
        end
        @threads << h.call(Input.mouse_pos_x, Input.mouse_pos_y)
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

    def loop
      Kernel.loop do
        yield
        Smalruby.await
      end
    end

    # 1フレーム待つ
    def await
      Smalruby.await
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
      self.angle = a
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
        @balloon.x = x + image.width / 2
        if @balloon.x < 0
          @balloon.x = 0
        elsif @balloon.x + @balloon.image.width >= Window.width
          @balloon.x = Window.width - @balloon.image.width
        end
        @balloon.y = y - @balloon.image.height
        if @balloon.y < 0
          @balloon.y = 0
        elsif @balloon.y + @balloon.image.height >= Window.height
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
  end
end
