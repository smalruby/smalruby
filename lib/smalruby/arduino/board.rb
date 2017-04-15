module Smalruby
  module Arduino
    class Board < Dino::Board
      def initialize
        super(Dino::TxRx::Serial.new)
      end
    end
  end
end