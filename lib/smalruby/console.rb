# -*- coding: utf-8 -*-
require 'readline'

module Smalruby
  # コンソールを表現するクラス
  #
  # コンソールとは、Windowsでは"コマンドプロンプト"、Macでは"ターミナル
  # "、Linuxでは"ターミナル"のことです。キーボードの操作を受け付けたり、
  # コマンドを実行したり、その実行結果を表示するために使います。
  #
  # @example 画面に「こんにちは、世界！」を表示する
  #    require 'smalruby'
  #    console1 = Console.new
  #    console1.on(:start) do
  #      puts('こんにちは、世界！')
  #    end
  #    start
  class Console < Character
    def initialize
      super
    end

    def loop(&block)
      Kernel.loop(&block)
    end

    # @!group 出力

    # @!method p(object)
    # データを読みやすい形に整形して表示します。
    # プログラムの途中経過を表示したりするときに使います。
    #
    # @param [Object] object 表示したいデータ
    # @return void
    #
    # @see Kernel.#p

    # @!method puts(message)
    # メッセージを表示します。
    #
    # @param [String] message メッセージ
    # @return void
    #
    # @see Kernel.#puts
    #
    # @example 縦に「こんにちは」と表示する
    #    require 'smalruby'
    #    console1 = Console.new
    #    console1.on(:start) do
    #      puts('こ')
    #      puts('ん')
    #      puts('に')
    #      puts('ち')
    #      puts('は')
    #    end
    #    start

    # @!method print(message)
    # メッセージを表示します。
    # メッセージの中に「\n」を含めないと改行されないため、続けてメッセー
    # ジを表示するときに使います。
    #
    # @param [String] message メッセージ
    # @return void
    #
    # @see Kernel.#print
    #
    # @example 横に「こんにちは」と表示する
    #    require 'smalruby'
    #    console1 = Console.new
    #    console1.on(:start) do
    #      print('こ')
    #      print('ん')
    #      print('に')
    #      print('ち')
    #      puts('は')
    #    end
    #    start

    # @!endgroup

    # @!group 入力

    # @!method readline(prompt = '')
    # returnキーを押すまでキーボードの操作を受け付けます。
    #
    # @param [String] prompt 画面の左端に表示する文字列
    # @return [String] キーボードから入力した文字列
    #
    # @see Readline.readline
    #
    # @example 「> 」を表示してキーボードからの操作を受け付ける
    #    require 'smalruby'
    #    console1 = Console.new
    #    console1.on(:start) do
    #      readline('> ')
    #    end
    #    start
    def_delegator :Readline, :readline

    # @!endgroup

    # @!group 実行

    # @!method system(program)
    # コマンドを実行します。
    #
    # @param [String] program コマンド
    # @return [bool] コマンドの実行に成功した場合はtrue
    #
    # @see Kernel.#system

    # コマンドの実行に成功した場合はtrueを返します。
    #
    # @return [bool] 直前のコマンドの実行結果
    #
    # @see $?
    def system_failed?
      return $CHILD_STATUS != 0
    end

    # @!endgroup
  end
end
