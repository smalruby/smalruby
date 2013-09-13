# -*- coding: utf-8 -*-
module Smalruby
  # イベントハンドラを表現するクラス
  class EventHandler
    attr_accessor :args
    attr_accessor :block

    # @param [Object] object 操作対象
    # @param [Array] args イベントハンドラの引数
    # @param [Proc] block イベントハンドラ
    def initialize(object, args, &block)
      @object = object
      @args = args
      @block = block
    end

    def call
      return Thread.start(@object, @block, @args) do |object, block, args|
        object.instance_exec(*args, &block)
      end
    end
  end
end
