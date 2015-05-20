# -*- coding: utf-8 -*-
require 'mutex_m'
require 'smalrubot'

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
    autoload :MotorDriver

    autoload :Button
    autoload :Sensor

    autoload :SmalrubotV3
    autoload :SmalrubotS1

    module_function

    # ハードウェアを準備する
    #
    # @param [Hash] options オプション
    # @option options [String] :device シリアルポートのデバイス名。
    #   WindowsだとCOM1など
    def init(options = {})
      return if @initialized_hardware

      defaults = {
        device: ENV["SMALRUBOT_DEVICE"] || nil,
        baud: 19_200,
      }
      opt = Util.process_options(options, defaults)

      txrx = Smalrubot::TxRx.new(opt)
      begin
        world.board = Smalrubot::Board.new(txrx)
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
    def create_hardware(klass, pin = nil)
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
