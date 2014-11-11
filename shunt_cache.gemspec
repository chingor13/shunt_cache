# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shunt_cache/version'

Gem::Specification.new do |spec|
  spec.name          = "shunt_cache"
  spec.version       = ShuntCache::VERSION
  spec.authors       = ["Jeff Ching"]
  spec.email         = ["ching.jeff@gmail.com"]
  spec.summary       = "Cache the site status in a cache"
  spec.description   = "Mark the site status in a cache"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock"
end
