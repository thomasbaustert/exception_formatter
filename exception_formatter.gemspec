# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exception_formatter/version'

Gem::Specification.new do |spec|
  spec.name          = "exception_formatter"
  spec.version       = ExceptionFormatter::VERSION
  spec.authors       = ["Thomas Baustert"]
  spec.email         = ["business@thomasbaustert.de"]
  spec.description   = %q{Simple formatter for ruby exception messages.}
  spec.summary       = %q{Simple formatter for ruby exception messages.}
  spec.homepage      = "https://github.com/thomasbaustert/exception_formatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
end
