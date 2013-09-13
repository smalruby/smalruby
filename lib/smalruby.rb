require 'smalruby/version'
require 'active_support'
require 'active_support/core_ext'

module Smalruby
  module_function

  def start
    begin
      world.objects.each do |object|
        object.start
      end
      while o = world.objects.detect(&:alive?)
        o.join
      end
    rescue SystemExit
    end
  end

  def world
    World.instance
  end
end

require 'smalruby/world'
require 'smalruby/base'
require 'smalruby/event_handler'

ActiveSupport::Dependencies.autoload_paths << File.expand_path('..', __FILE__)
