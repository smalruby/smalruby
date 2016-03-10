# -*- coding: utf-8 -*-

module Smalruby
  # ステージを表現するクラス
  class Stage < Canvas
    def initialize(options = {})
      defaults = {
        color: 'white'
      }
      opts = Util.process_options(options, defaults)

      super(opts.reject { |k, _| defaults.keys.include?(k) })

      @background_color = opts[:color]

      # HACK: ステージを一番最初に描画する
      World.instance.objects.delete(self)
      World.instance.objects.unshift(self)
      World.instance.current_stage = self

      clear
    end

    # clear with background color or image
    def clear
      fill(color: @background_color)
    end
  end
end
