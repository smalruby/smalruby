# -*- coding: utf-8 -*-

DESCRIPTION = <<EOS
スモウルボットS1を操作します
EOS

require 'smalruby'
require_relative 'check_hardware_smalrubot'

init_hardware(device: ENV['SMALRUBOT_DEVICE'],
              baud: ENV['SMALRUBOT_BAUD'] ? ENV['SMALRUBOT_BAUD'].to_i : nil)

stage1 = Stage.new(color: 'white')
setup_smalrubot(stage1, stage1.smalrubot_s1)
