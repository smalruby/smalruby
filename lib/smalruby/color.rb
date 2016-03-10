# -*- coding: utf-8 -*-

module Smalruby
  # 色を表現するモジュール
  module Color
    # 名前から色のコードへの変換テーブル
    # 参照: http://www.colordic.org/
    NAME_TO_CODE = {
      'black' => [0x00, 0x00, 0x00],
      'dimgray' => [0x69, 0x69, 0x69],
      'gray' => [0x80, 0x80, 0x80],
      'darkgray' => [0xa9, 0xa9, 0xa9],
      'silver' => [0xc0, 0xc0, 0xc0],
      'lightgrey' => [0xd3, 0xd3, 0xd3],
      'gainsboro' => [0xdc, 0xdc, 0xdc],
      'whitesmoke' => [0xf5, 0xf5, 0xf5],
      'white' => [0xff, 0xff, 0xff],
      'snow' => [0xff, 0xfa, 0xfa],
      'ghostwhite' => [0xf8, 0xf8, 0xff],
      'floralwhite' => [0xff, 0xfa, 0xf0],
      'linen' => [0xfa, 0xf0, 0xe6],
      'antiquewhite' => [0xfa, 0xeb, 0xd7],
      'papayawhip' => [0xff, 0xef, 0xd5],
      'blanchedalmond' => [0xff, 0xeb, 0xcd],
      'bisque' => [0xff, 0xe4, 0xc4],
      'moccasin' => [0xff, 0xe4, 0xb5],
      'navajowhite' => [0xff, 0xde, 0xad],
      'peachpuff' => [0xff, 0xda, 0xb9],
      'mistyrose' => [0xff, 0xe4, 0xe1],
      'lavenderblush' => [0xff, 0xf0, 0xf5],
      'seashell' => [0xff, 0xf5, 0xee],
      'oldlace' => [0xfd, 0xf5, 0xe6],
      'ivory' => [0xff, 0xff, 0xf0],
      'honeydew' => [0xf0, 0xff, 0xf0],
      'mintcream' => [0xf5, 0xff, 0xfa],
      'azure' => [0xf0, 0xff, 0xff],
      'aliceblue' => [0xf0, 0xf8, 0xff],
      'lavender' => [0xe6, 0xe6, 0xfa],
      'lightsteelblue' => [0xb0, 0xc4, 0xde],
      'lightslategray' => [0x77, 0x88, 0x99],
      'slategray' => [0x70, 0x80, 0x90],
      'steelblue' => [0x46, 0x82, 0xb4],
      'royalblue' => [0x41, 0x69, 0xe1],
      'midnightblue' => [0x19, 0x19, 0x70],
      'navy' => [0x00, 0x00, 0x80],
      'darkblue' => [0x00, 0x00, 0x8b],
      'mediumblue' => [0x00, 0x00, 0xcd],
      'blue' => [0x00, 0x00, 0xff],
      'dodgerblue' => [0x1e, 0x90, 0xff],
      'cornflowerblue' => [0x64, 0x95, 0xed],
      'deepskyblue' => [0x00, 0xbf, 0xff],
      'lightskyblue' => [0x87, 0xce, 0xfa],
      'skyblue' => [0x87, 0xce, 0xeb],
      'lightblue' => [0xad, 0xd8, 0xe6],
      'powderblue' => [0xb0, 0xe0, 0xe6],
      'paleturquoise' => [0xaf, 0xee, 0xee],
      'lightcyan' => [0xe0, 0xff, 0xff],
      'cyan' => [0x00, 0xff, 0xff],
      'aqua' => [0x00, 0xff, 0xff],
      'turquoise' => [0x40, 0xe0, 0xd0],
      'mediumturquoise' => [0x48, 0xd1, 0xcc],
      'darkturquoise' => [0x00, 0xce, 0xd1],
      'lightseagreen' => [0x20, 0xb2, 0xaa],
      'cadetblue' => [0x5f, 0x9e, 0xa0],
      'darkcyan' => [0x00, 0x8b, 0x8b],
      'teal' => [0x00, 0x80, 0x80],
      'darkslategray' => [0x2f, 0x4f, 0x4f],
      'darkgreen' => [0x00, 0x64, 0x00],
      'green' => [0x00, 0x80, 0x00],
      'forestgreen' => [0x22, 0x8b, 0x22],
      'seagreen' => [0x2e, 0x8b, 0x57],
      'mediumseagreen' => [0x3c, 0xb3, 0x71],
      'mediumaquamarine' => [0x66, 0xcd, 0xaa],
      'darkseagreen' => [0x8f, 0xbc, 0x8f],
      'aquamarine' => [0x7f, 0xff, 0xd4],
      'palegreen' => [0x98, 0xfb, 0x98],
      'lightgreen' => [0x90, 0xee, 0x90],
      'springgreen' => [0x00, 0xff, 0x7f],
      'mediumspringgreen' => [0x00, 0xfa, 0x9a],
      'lawngreen' => [0x7c, 0xfc, 0x00],
      'chartreuse' => [0x7f, 0xff, 0x00],
      'greenyellow' => [0xad, 0xff, 0x2f],
      'lime' => [0x00, 0xff, 0x00],
      'limegreen' => [0x32, 0xcd, 0x32],
      'yellowgreen' => [0x9a, 0xcd, 0x32],
      'darkolivegreen' => [0x55, 0x6b, 0x2f],
      'olivedrab' => [0x6b, 0x8e, 0x23],
      'olive' => [0x80, 0x80, 0x00],
      'darkkhaki' => [0xbd, 0xb7, 0x6b],
      'palegoldenrod' => [0xee, 0xe8, 0xaa],
      'cornsilk' => [0xff, 0xf8, 0xdc],
      'beige' => [0xf5, 0xf5, 0xdc],
      'lightyellow' => [0xff, 0xff, 0xe0],
      'lightgoldenrodyellow' => [0xfa, 0xfa, 0xd2],
      'lemonchiffon' => [0xff, 0xfa, 0xcd],
      'wheat' => [0xf5, 0xde, 0xb3],
      'burlywood' => [0xde, 0xb8, 0x87],
      'tan' => [0xd2, 0xb4, 0x8c],
      'khaki' => [0xf0, 0xe6, 0x8c],
      'yellow' => [0xff, 0xff, 0x00],
      'gold' => [0xff, 0xd7, 0x00],
      'orange' => [0xff, 0xa5, 0x00],
      'sandybrown' => [0xf4, 0xa4, 0x60],
      'darkorange' => [0xff, 0x8c, 0x00],
      'goldenrod' => [0xda, 0xa5, 0x20],
      'peru' => [0xcd, 0x85, 0x3f],
      'darkgoldenrod' => [0xb8, 0x86, 0x0b],
      'chocolate' => [0xd2, 0x69, 0x1e],
      'sienna' => [0xa0, 0x52, 0x2d],
      'saddlebrown' => [0x8b, 0x45, 0x13],
      'maroon' => [0x80, 0x00, 0x00],
      'darkred' => [0x8b, 0x00, 0x00],
      'brown' => [0xa5, 0x2a, 0x2a],
      'firebrick' => [0xb2, 0x22, 0x22],
      'indianred' => [0xcd, 0x5c, 0x5c],
      'rosybrown' => [0xbc, 0x8f, 0x8f],
      'darksalmon' => [0xe9, 0x96, 0x7a],
      'lightcoral' => [0xf0, 0x80, 0x80],
      'salmon' => [0xfa, 0x80, 0x72],
      'lightsalmon' => [0xff, 0xa0, 0x7a],
      'coral' => [0xff, 0x7f, 0x50],
      'tomato' => [0xff, 0x63, 0x47],
      'orangered' => [0xff, 0x45, 0x00],
      'red' => [0xff, 0x00, 0x00],
      'crimson' => [0xdc, 0x14, 0x3c],
      'mediumvioletred' => [0xc7, 0x15, 0x85],
      'deeppink' => [0xff, 0x14, 0x93],
      'hotpink' => [0xff, 0x69, 0xb4],
      'palevioletred' => [0xdb, 0x70, 0x93],
      'pink' => [0xff, 0xc0, 0xcb],
      'lightpink' => [0xff, 0xb6, 0xc1],
      'thistle' => [0xd8, 0xbf, 0xd8],
      'magenta' => [0xff, 0x00, 0xff],
      'fuchsia' => [0xff, 0x00, 0xff],
      'violet' => [0xee, 0x82, 0xee],
      'plum' => [0xdd, 0xa0, 0xdd],
      'orchid' => [0xda, 0x70, 0xd6],
      'mediumorchid' => [0xba, 0x55, 0xd3],
      'darkorchid' => [0x99, 0x32, 0xcc],
      'darkviolet' => [0x94, 0x00, 0xd3],
      'darkmagenta' => [0x8b, 0x00, 0x8b],
      'purple' => [0x80, 0x00, 0x80],
      'indigo' => [0x4b, 0x00, 0x82],
      'darkslateblue' => [0x48, 0x3d, 0x8b],
      'blueviolet' => [0x8a, 0x2b, 0xe2],
      'mediumpurple' => [0x93, 0x70, 0xdb],
      'slateblue' => [0x6a, 0x5a, 0xcd],
      'mediumslateblue' => [0x7b, 0x68, 0xee]
    }

    # 3 = R, G, B,  2 = Up, Down
    HUE_PER_6 = 200.0 / (3.0 * 2.0)

    # 色名の配列
    NAMES = NAME_TO_CODE.keys

    module_function

    # Smalrubyの色名からDXRubyの色コードに変換する
    def smalruby_to_dxruby(color)
      if color.is_a?(String) || color.is_a?(Symbol)
        color = color.to_s.downcase
        if color == 'random'
          [rand(0..0xff), rand(0..0xff), rand(0..0xff)]
        elsif NAME_TO_CODE.key?(color)
          NAME_TO_CODE[color]
        else
          fail "色の指定が間違っています: #{color}"
        end
      else
        color
      end
    end

    # Convert RGB Color model to HSL Color model
    #
    # @param [Integer] red
    # @param [Integer] green
    # @param [Integer] blue
    # @return [Array] hue, saturation, lightness
    #   hue in the range [0,200],
    #   saturation and lightness in the range [0, 100]
    def rgb_to_hsl(red, green, blue)
      red = round_rgb_color(red)
      green = round_rgb_color(green)
      blue = round_rgb_color(blue)

      color_max = [red, green, blue].max
      color_min = [red, green, blue].min
      color_range = color_max - color_min
      if color_range == 0
        return [0, 0, (color_max * 100.0 / 255).to_i]
      end
      color_range = color_range.to_f
      hue = (case color_max
             when red then
               HUE_PER_6 * ((green - blue) / color_range)
             when green  then
               HUE_PER_6 * ((blue - red) / color_range) + HUE_PER_6 * 2
             else
               HUE_PER_6 * ((red - green) / color_range) + HUE_PER_6 * 4
             end)

      cnt = color_range / 2.0
      if cnt <= 127
        saturation = color_range / (color_max + color_min) * 100
      else
        saturation = color_range / (510 - color_max - color_min) * 100
      end
      lightness = (color_max + color_min) / 2.0 / 255.0 * 100

      [hue.round, saturation.round, lightness.round]
    end

    # Round rgb color 0 to 255
    #
    # @param [Integer] value RGB color
    # @return [Integer] rounded RGB color
    def round_rgb_color(value)
      if value > 255
        255
      elsif value < 0
        0
      else
        value
      end
    end

    # Convert HSV Color model to RGB Color model
    #
    # @param [Integer] h
    # @param [Integer] s
    # @param [Integer] l
    # @return [Array] red,green,blue color
    #   red,green,blue in the range [0,255]
    def hsl_to_rgb(h, s, l)
      h %= 201
      s %= 101
      l %= 101
      if l <= 49
        color_max = 255.0 * (l + l * (s / 100.0)) / 100.0
        color_min = 255.0 * (l - l * (s / 100.0)) / 100.0
      else
        color_max = 255.0 * (l + (100 - l) * (s / 100.0)) / 100.0
        color_min = 255.0 * (l - (100 - l) * (s / 100.0)) / 100.0
      end

      if h < HUE_PER_6
        base = h
      elsif h < HUE_PER_6 * 3
        base = (h - HUE_PER_6 * 2).abs
      elsif h < HUE_PER_6 * 5
        base = (h - HUE_PER_6 * 4).abs
      else
        base = (200 - h)
      end
      base = base / HUE_PER_6 * (color_max - color_min) + color_min

      divide = (h / HUE_PER_6).to_i
      red, green, blue = (case divide
                          when 0 then  [color_max, base, color_min]
                          when 1 then  [base, color_max, color_min]
                          when 2 then  [color_min, color_max, base]
                          when 3 then  [color_min, base, color_max]
                          when 4 then  [base, color_min, color_max]
                          else         [color_max, color_min, base]
                          end)

      [red.round, green.round, blue.round]
    end
  end
end
