require 'smalruby/version'
require 'active_support/all'
require 'dxruby'

require 'smalruby/world'
require 'smalruby/base'
require 'smalruby/event_handler'

module Smalruby
  extend ActiveSupport::Autoload

  autoload :Console

  module_function

  @@started = false

  def start
    @@started = true
    begin
      Window.caption = File.basename($0)
      first = true
      Window.loop do
        if first
          world.objects.each do |object|
            object.start
          end
          first = false
        end
        if !world.objects.any?(&:alive?)
          break
        end
      end
    rescue SystemExit
    end
    while o = world.objects.detect(&:alive?)
      o.join
    end
  end

  def started?
    return @@started
  end

  def world
    World.instance
  end
end

include Smalruby

END {
  if !started?
    start
  end
}
