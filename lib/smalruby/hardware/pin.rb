# -*- coding: utf-8 -*-
require 'dino'

module Smalruby
  module Hardware
    module Pin
      module_function

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
        when /\A[0-9]|1[0-3]\z/
          pin.to_i
        when /\AD[0-9]|D1[0-3]\z/
          pin[1..-1].to_i
        when /\AA[0-5]\z/
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
        when /\A[0-9]|1[0-3]\z/
          "D#{pin}"
        when /\AD[0-9]|D1[0-3]\z/
          pin
        when /\AA[0-5]\z/
          pin
        else
          fail "ハードウェアのピンの番号が間違っています: #{pin}"
        end
      end
    end
  end
end
