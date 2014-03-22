# -*- coding: utf-8 -*-

# rubocop:disable all

# WindowsでのDinoの不具合を修正するモンキーパッチ
if Util.windows?
  require 'dino'

  if Dino::VERSION >= '0.11'
    class Dino::TxRx::Base
      def gets(timeout = 0.005)
        return nil unless IO.select([io], nil, nil, timeout)
        io.read_timeout = (timeout * 1000).to_i
        bytes = []
        until (x = io.getbyte).nil?
          bytes.push(x)
        end
        return nil if bytes.empty?
        bytes.pack("C*")
      end
    end
  elsif Dino::VERSION >= '0.10'
    class Dino::TxRx::USBSerial
      def read
        @thread ||= Thread.new do
          loop do
            line = gets
            if line
              pin, message = *line.chomp.split(/::/)
              pin && message && changed && notify_observers(pin, message)
            end
            sleep 0.004
          end
        end
      end

      def gets(timeout = 0.005)
        return nil unless IO.select([io], nil, nil, timeout)
        io.read_timeout = (timeout * 1000).to_i
        bytes = []
        until (x = io.getbyte).nil?
          bytes.push(x)
        end
        return nil if bytes.empty?
        bytes.pack("C*")
      end
    end
  else
    fail "Dinoのバージョン#{version}はサポートしていません"
  end
end
