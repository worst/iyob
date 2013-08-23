# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iyob/version'

Gem::Specification.new do |spec|
  spec.name          = "iyob"
  spec.version       = Iyob::VERSION
  spec.authors       = ["Jeremy Blackburn"]
  spec.email         = ["jeremy.blackburn@gmail.com"]
  spec.description   = %q{A client for the SMITE API}
  spec.summary       = %q{A client for the SMITE API}
  spec.homepage      = "http://github.com/worst/iyob"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "mechanize"
end
