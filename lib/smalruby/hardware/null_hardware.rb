# -*- coding: utf-8 -*-
require 'smalruby/hardware'

module Smalruby
  module Hardware
    # 何もしないハードウェアを表現するクラス
    class NullHardware
      def initialize(*_)
      end

      def method_missing(name)
      end
    end
  end
end
