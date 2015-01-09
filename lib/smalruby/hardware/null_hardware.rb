# -*- coding: utf-8 -*-
require 'smalruby/hardware'
require 'delegate'

module Smalruby
  module Hardware
    # 何もしないハードウェアを表現するクラス
    class NullHardware
      def initialize(*_)
      end

      def method_missing(*_name)
        @null ||= NullHardware.new
      end

      %i(& ^ nil? to_a to_f to_i to_s |).each do |sym|
        define_method sym do |*args|
          nil.send(sym, *args)
        end
      end
    end
  end
end
