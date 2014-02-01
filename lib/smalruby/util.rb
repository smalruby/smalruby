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
      /windows|mingw|cygwin/i =~ RbConfig::CONFIG['arch']
    end
  end
end
