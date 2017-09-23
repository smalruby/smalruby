# -*- coding: utf-8 -*-

module Smalruby
  class Mouse
    def self.position(dxruby_x = Input.mouse_pos_x, dxruby_y = Input.mouse_pos_y)
      cs = CordinateSystem.new(nil, 0, 0)
      cs.dxruby_x = dxruby_x
      cs.dxruby_y = dxruby_y
      cs.to_a
    end
  end
end
