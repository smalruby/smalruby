require 'smalruby/version'
require 'active_support'

module Smalruby
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Console

  module_function

  def start
  end
end

include Smalruby
