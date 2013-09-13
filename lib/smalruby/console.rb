require_relative 'base'
require 'readline'

module Smalruby
  class Console < Base
    def_delegator :Readline, :readline
  end
end
