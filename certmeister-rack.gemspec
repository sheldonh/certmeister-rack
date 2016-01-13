# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'certmeister/rack/version'

Gem::Specification.new do |spec|
  spec.name          = "certmeister-rack"
  spec.version       = Certmeister::Rack::VERSION
  spec.authors       = ["Sheldon Hearn"]
  spec.email         = ["sheldonh@starjuice.net"]
  spec.summary       = %q{Rack application for certmeister}
  spec.description   = %q{This gem provides a rack application to offer an HTTP service around certmeister, the conditional autosigning certificate authority.}
  spec.homepage      = "https://github.com/sheldonh/certmeister-rack"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z lib/certmeister spec/certmeister`.split("\x0").grep(/rack/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "certmeister", "~> 2.3"
  spec.add_dependency "rack", "~> 1.5"

  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "rake", "~> 10.4.2"
  spec.add_development_dependency "rspec", "~> 3.1"
end
