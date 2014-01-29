# -*- coding: utf-8 -*-
require 'singleton'

module Smalruby
  # 環境を表現するクラス
  class World
    include Singleton

    attr_accessor :objects
    attr_accessor :board

    def initialize
      @objects = []
      @board = nil
    end
  end
end
