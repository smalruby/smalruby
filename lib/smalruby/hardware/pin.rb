# -*- coding: utf-8 -*-
require 'dino'

module Smalruby
  module Hardware
    module Pin
      module_function

      DIO_DINO_RE = /\A([0-9]|1[0-3])\z/
      DIO_SMALRUBY_RE = /\AD([0-9]|1[0-3])\z/
      AI_RE = /\AA[0-5]\z/

      # Smalrubyのピン番号をDinoのピン番号に変換する
      #
      # ピン番号が0～13、D0～D13、A0～A5でなければ例外が発生する
      #
      # @param [String|Numeric] pin Smalrubyのピン番号
      # @return [Numeric] Dinoのデジタル入出力のピン番号
      # @return [String] Dinoのアナログ入力のピン番号
      def smalruby_to_dino(pin)
        pin = pin.to_s
        case pin
        when DIO_DINO_RE
          pin.to_i
        when DIO_SMALRUBY_RE
          pin[1..-1].to_i
        when AI_RE
          pin
        else
          fail "ハードウェアのピンの番号が間違っています: #{pin}"
        end
      end

      # Dinoのピン番号をSmalrubyのピン番号に変換する
      #
      # ピン番号が0～13、D0～D13、A0～A5でなければ例外が発生する
      #
      # @param [String|Numeric] pin Dinoのピン番号
      # @return [String] Smalrubyのピン番号
      def dino_to_smalruby(pin)
        pin = pin.to_s
        case pin
        when DIO_DINO_RE
          "D#{pin}"
        when DIO_SMALRUBY_RE
          pin
        when AI_RE
          pin
        else
          fail "ハードウェアのピンの番号が間違っています: #{pin}"
        end
      end
    end
  end
end
