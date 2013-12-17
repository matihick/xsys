# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xsys/version'

Gem::Specification.new do |s|
  s.name          = "xsys"
  s.version       = Xsys::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Matias Hick"]
  s.email         = ["me@unformatt.com.ar"]
  s.homepage      = "https://github.com/unformattmh/xsys"
  s.summary       = "Get data from xsys api"
  s.description   = "Get data from xsys api"
  s.license       = "MIT"

  s.files         = Dir["LICENSE.md", "README.md", "lib/**/*"]
  s.executables   = []
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"

  s.add_runtime_dependency "rest-client", "~> 1.6.7"
end
