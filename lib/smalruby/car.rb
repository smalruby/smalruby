# -*- coding: utf-8 -*-
require 'readline'

module Smalruby
  # 車を表現するクラス
  class Car < Base
    def initialize(x = 0, y = 0, type = '1')
      super(x, y, Image.load(asset_path("car#{type}.png")))
    end
  end
end
