# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spoofer/version'

Gem::Specification.new do |spec|
  spec.name = "spoofer"
  spec.version = Spoofer::VERSION

  spec.authors       = ["Justin Smestad"]
  spec.email         = "justin.smestad@gmail.com"
  spec.description   = %q{A Ruby gem for faking external web services for testing}
  spec.summary       = %q{A Ruby gem for faking external web services for testing}
  spec.homepage      = "https://github.com/jsmestad/poser"

  spec.files         = Dir["{lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'thin'
  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'plist', "~> 3.1"

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-expectations'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'rest-client'
end
