# -*- coding: utf-8 -*-

# rubocop:disable all

# WindowsでのDinoの不具合を修正するモンキーパッチ
if Util.windows?
  require 'dino'

  if Dino::VERSION >= '0.11'
    require 'mutex_m'

    class Dino::TxRx::Base
      def write(message)
        loop do
          if IO.select(nil, [io], nil)
            io.synchronize { io.syswrite(message) }
            break
          end
        end
      end

      def gets(timeout = 0.005)
        @buffer ||= ""
        if !@buffer.include?("\n")
          return nil unless IO.select([io], nil, nil, timeout)
          io.synchronize do
            io.read_timeout = (timeout * 1000).to_i
          end
          bytes = []
          until (x = io.synchronize { io.getbyte }).nil?
            bytes.push(x)
          end
          return nil if bytes.empty?
          @buffer += bytes.pack("C*")
        end
        @buffer.slice!(/\A[^\n]*\n/)
      end
    end

    class Dino::TxRx::Serial
      def io
        unless @io
          @io = connect
          @io.extend(Mutex_m)
        end
        @io
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
