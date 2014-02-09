# -*- coding: utf-8 -*-

module Smalruby
  # ステージを表現するクラス
  class Stage < Canvas
    def initialize(options = {})
      defaults = {
        color: 'black'
      }
      opts = Util.process_options(options, defaults)

      super(opts.reject { |k, v| defaults.keys.include?(k) })

      fill(color: opts[:color])
    end
  end
end
