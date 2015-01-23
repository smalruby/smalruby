# -*- coding: utf-8 -*-
require 'singleton'

module Smalruby
  # 環境を表現するクラス
  class World
    include Singleton

    attr_accessor :objects
    attr_accessor :board
    attr_accessor :current_stage

    def initialize
      @objects = []
      @board = nil
    end
  end
end
