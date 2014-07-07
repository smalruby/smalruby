# -*- coding: utf-8 -*-
module Smalruby
  module Util
    module_function

    def process_options(options, defaults)
      unknown_keys = options.keys - defaults.keys
      if unknown_keys.length > 0
        s = unknown_keys.map { |k| "#{k}: #{options[k].inspect}" }.join(', ')
        fail ArgumentError, "Unknown options: #{s}"
      end
      defaults.merge(options)
    end

    def print_exception(exception)
      $stderr.puts("#{exception.class}: #{exception.message}")
      $stderr.puts("        #{exception.backtrace.join("\n        ")}")
    end

    # プラットフォームがWindowsかどうかを返す
    #
    # @return [Boolean] Windowsの場合はtrue、そうでない場合はfalseを返す
    def windows?
      ENV['SMALRUBY_WINDOWS_MODE'] || /windows|mingw|cygwin/i =~ RbConfig::CONFIG['arch']
    end

    # プラットフォームがRaspberry Piかどうかを返す
    #
    # @return [Boolean] Raspberry Piの場合はtrue、そうでない場合はfalseを返す
    def raspberrypi?
      ENV['SMALRUBY_RASPBERRYPI_MODE'] || /armv6l-linux-eabihf/i =~ RbConfig::CONFIG['arch']
    end

    # プラットフォームがMac OS Xかどうかを返す
    #
    # @return [Boolean] Mac OS Xの場合はtrue、そうでない場合はfalseを返す
    def osx?
      ENV['SMALRUBY_OSX_MODE'] || /darwin/i =~ RbConfig::CONFIG['arch']
    end
  end
end
