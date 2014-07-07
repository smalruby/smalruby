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
      @running = false
    end

    def call(*args)
      return nil if @running
      return Thread.start(@object, @block) { |object, block|
        begin
          @running = true
          object.instance_exec(*args, &block)
        ensure
          @running = false
        end
      }
    end
  end
end
