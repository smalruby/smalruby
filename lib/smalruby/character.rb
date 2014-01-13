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

    attr_accessor :event_handlers
    attr_accessor :threads
    attr_accessor :checking_hit_targets

    def initialize(option = {})
      opt = {
        x: 0,
        y: 0,
        costume: nil,
        visible: true
      }.merge(option)

      # TODO: コスチュームの配列に対応する
      if opt[:costume].is_a?(String)
        opt[:costume] = Image.load(asset_path(opt[:costume]))
      end
      super(opt[:x], opt[:y], opt[:costume])

      @event_handlers = {}
      @threads = []
      @checking_hit_targets = []

      self.scale_x = 1.0
      self.scale_y = 1.0
      @vector = { x: 1, y: 0 }

      [:visible].each do |k|
        if opt.key?(k)
          send("#{k}=", opt[k])
        end
      end

      World.instance.objects << self
    end

    # @!group 動き

    # (  )歩動かす
    def move(val = 1)
      self.x += @vector[:x] * val
      self.y += @vector[:y] * val
    end

    # (  )歩後ろに動かす
    def move_back(val = 1)
      move(-val)
    end

    # 振り返る
    def turn
      @vector[:x] *= -1
      @vector[:y] *= -1
      self.scale_x *= -1
    end

    # もし端に着いたら、跳ね返る
    def turn_if_reach_wall
      turn if reach_wall?
    end

    # (  )度回転する
    def rotate(angle)
      radian = angle * Math::PI / 180
      x, y = @vector[:x], @vector[:y]
      @vector[:x] = x * Math.cos(radian) - y * Math.sin(radian)
      @vector[:y] = x * Math.sin(radian) + y * Math.cos(radian)
      self.angle = (self.angle + angle) % 360
    end

    # @!endgroup

    # @!group 見た目

    def say(message)
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
      image.draw_font(frame_size + margin_size,
                      frame_size + margin_size,
                      lines.join("\n"), font, [0, 0, 0])
      @balloon = Sprite.new(self.x, self.y, image)
    end

    # @!endgroup

    # @!group 調べる

    # 距離
    def distance(x, y)
      Math.sqrt((self.x + center_x - x).abs**2 +
                (self.y + center_y - y).abs**2).to_i
    end

    # 端に着いた
    def reach_wall?
      self.x < 0 || self.x >= (Window.width - image.width) ||
        self.y < 0 || self.y >= (Window.height - image.height)
    end

    # @!endgroup

    # @!group 音

    def play(option = {})
      @sound_cache ||= {}
      (@sound_cache[option[:name]] ||= Sound.new(asset_path(option[:name])))
        .play
    end

    # @!endgroup

    def draw
      draw_balloon

      if self.x < 0
        self.x = 0
      elsif self.x + image.width >= Window.width
        self.x = Window.width - image.width
      end
      if self.y < 0
        self.y = 0
      elsif self.y + image.height >= Window.height
        self.y = Window.height - image.height
      end
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
      return @threads.any?(&:alive?)
    end

    def join
      @threads.each(&:join)
    end

    def loop(&block)
      Kernel.loop do
        yield
        Smalruby.await
      end
    end

    private

    def asset_path(name)
      program_path = Pathname($PROGRAM_NAME).expand_path(Dir.pwd)
      paths = [Pathname("../#{name}").expand_path(program_path),
               Pathname("../../../assets/#{name}").expand_path(__FILE__)]
      paths.find { |path| path.file? }.to_s
    end

    def new_font(size)
      self.class.font_cache.synchronize do
        self.class.font_cache[size] ||= Font.new(size)
      end
      return self.class.font_cache[size]
    end

    def draw_balloon
      if @balloon
        @balloon.x = self.x + image.width / 2
        if @balloon.x < 0
          @balloon.x = 0
        elsif @balloon.x + @balloon.image.width >= Window.width
          @balloon.x = Window.width - @balloon.image.width
        end
        @balloon.y = self.y - @balloon.image.height
        if @balloon.y < 0
          @balloon.y = 0
        elsif @balloon.y + @balloon.image.height >= Window.height
          @balloon.y = Window.height - @balloon.image.height
        end
        @balloon.draw
      end
    end
  end
end
