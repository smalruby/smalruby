# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smalruby/version'

Gem::Specification.new do |spec|
  platform = ENV['GEM_PLATFORM'] || Gem::Platform.local.to_s
  is_windows = /windows|mingw|cygwin/i.match(platform)

  spec.name          = 'smalruby'
  if is_windows
    spec.platform      = 'x86-mingw32'
  end
  spec.version       = Smalruby::VERSION
  spec.authors       = ['Kouji Takao']
  spec.email         = ['kouji.takao@gmail.com']
  spec.description   = %q{smalruby is a 2D game development library. This is part of "Smalruby" project that is a learning ruby programming environment for kids.}
  spec.summary       = %q{2D game development library for kids.}
  spec.homepage      = 'https://github.com/smalruby/smalruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'travis-lint'
  spec.add_development_dependency 'rubocop', '~> 0.16'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'

  spec.add_runtime_dependency 'mime-types', '~> 1.6'
  spec.add_runtime_dependency 'activesupport'
  if is_windows
    spec.add_runtime_dependency 'dxruby', '1.4.0'
  else
    spec.add_runtime_dependency 'dxruby_sdl', '~> 0.0.10'
  end
  spec.add_runtime_dependency 'dino', '~> 0.11.2'
end
