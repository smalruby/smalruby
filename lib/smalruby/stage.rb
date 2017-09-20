# -*- coding: utf-8 -*-

module Smalruby
  # ステージを表現するクラス
  class Stage < Canvas
    def initialize(options = {})
      defaults = {
        costume: nil,
        costume_index: 0,
        color: 'white'
      }
      opts = Util.process_options(options, defaults)

      @background_name__index = {}
      @backgrounds = Array.wrap(opts[:costume]).compact.map.with_index { |costume, i|
        if costume.is_a?(String)
          md = /^(?:([^:]+):)?(.*)$/.match(costume)
          name = md[1]
          path = md[2]
          costume = Image.load(asset_path(path))
        end
        name ||= "costume#{i + 1}"
        @background_name__index[name] = i
        costume
      }
      @background_index = opts[:costume_index]

      super(opts.reject { |k, _| %i(costume costume_index).include?(k) })

      @background_color = opts[:color]
      draw_background

      # HACK: ステージを一番最初に描画する
      World.instance.objects.delete(self)
      World.instance.objects.unshift(self)
      World.instance.current_stage = self
    end

    # clear with background color or image
    def clear
      fill(color: @background_color)
      draw_background
    end

    def draw_background
      if @backgrounds.empty?
        return
      end

      image.draw(0, 0, @backgrounds[@background_index])
    end
  end
end
