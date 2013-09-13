# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smalruby/version'

Gem::Specification.new do |spec|
  spec.name          = "smalruby"
  spec.version       = Smalruby::VERSION
  spec.authors       = ["Kouji Takao"]
  spec.email         = ["kouji.takao@gmail.com"]
  spec.description   = %q{smalruby is a 2D game development library. This is part of "Smalruby" project that is a learning ruby programming environment for kids.}
  spec.summary       = %q{2D game development library for kids.}
  spec.homepage      = "https://github.com/smalruby/smalruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
