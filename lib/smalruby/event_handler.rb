# -*- coding: utf-8 -*-
module Smalruby
  # イベントハンドラを表現するクラス
  class EventHandler
    attr_accessor :object
    attr_accessor :options
    attr_accessor :block

    # @param [Object] object 操作対象
    # @param [Array] options イベントハンドラのオプション
    # @param [Proc] block イベントハンドラ
    def initialize(object, options, &block)
      @object = object
      @options = options
      @block = block
    end

    def call(*args)
      return Thread.start(@object, @block) { |object, block|
               object.instance_exec(*args, &block)
             }
    end
  end
end
