# -*- coding: utf-8 -*-
require 'dino'

module Smalruby
  # ハードウェアの名前空間
  module Hardware
    extend ActiveSupport::Autoload

    autoload :Led

    module_function

    def init(options = {})
      return if @initialized_hardware
      fail 'already started.' if @started

      defaults = {
        device: nil,
      }
      opt = Util.process_options(options, defaults)

      txrx = Dino::TxRx.new
      txrx.io = opt[:device] if opt[:device]
      world.board = Dino::Board.new(txrx)

      @initialized_hardware = true
    end

    private

    @initialized_hardware = false
  end
end
