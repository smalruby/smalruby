# -*- coding: utf-8 -*-
require 'dino'
require 'mutex_m'
require_relative 'hardware/dino/fix_gets'

module Smalruby
  # ハードウェアの名前空間
  module Hardware
    extend ActiveSupport::Autoload

    autoload :NullHardware

    autoload :Pin
    autoload :Led
    autoload :RgbLedAnode
    autoload :RgbLedCathode
    autoload :Servo
    autoload :TwoWheelDriveCar

    autoload :Button
    autoload :Sensor

    module_function

    # ハードウェアを準備する
    #
    # @param [Hash] options オプション
    # @option options [String] :device シリアルポートのデバイス名。
    #   WindowsだとCOM1など
    def init(options = {})
      return if @initialized_hardware

      defaults = {
        device: nil,
        baud: 115_200,
        heart_rate: 40 # HACK: 実機で調整した値
      }
      opt = Util.process_options(options, defaults)

      if Dino::VERSION >= '0.11'
        txrx = Dino::TxRx.new(opt)
      elsif Dino::VERSION >= '0.10'
        txrx = Dino::TxRx.new
        txrx.io = opt[:device] if opt[:device]
      end
      begin
        world.board = Dino::Board.new(txrx)
        world.board.heart_rate = opt[:heart_rate]

        @initialized_hardware = true
      rescue Exception
        Util.print_exception($!)
        @failed_init_hardware = true
      end
    end

    # ハードウェアを停止させる
    def stop
      @hardware_cache.synchronize do
        @hardware_cache.values.each do |h|
          h.stop if h.respond_to?(:stop)
        end
        @hardware_cache.clear
      end
    end

    # ハードウェアの初期化に失敗したかどうかを返す
    def failed?
      @failed_init_hardware
    end

    # ハードウェアのインスタンスを生成する
    #
    # 作成したハードウェアのインスタンスはキャッシュする
    #
    # @param [Class] klass ハードウェアのクラス
    # @param [String|Numeric] pin ピン番号
    # @return [Object] ハードウェアのインスタンス
    def create_hardware(klass, pin)
      klass = NullHardware unless @initialized_hardware
      key = [klass, pin]
      @hardware_cache.synchronize do
        @hardware_cache[key] ||= klass.new(pin: pin)
      end
      @hardware_cache[key]
    end

    private

    @initialized_hardware = false
    @failed_init_hardware = false
    @hardware_cache = {}
    @hardware_cache.extend(Mutex_m)
  end
end
