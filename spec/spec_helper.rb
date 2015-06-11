# -*- coding: utf-8 -*-

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'smalruby'
Smalruby.instance_variable_set("@started", true)

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)).each do |path|
  require path
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
