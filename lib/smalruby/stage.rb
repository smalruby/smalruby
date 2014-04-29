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

      fill(color: opts[:color])
    end
  end
end
