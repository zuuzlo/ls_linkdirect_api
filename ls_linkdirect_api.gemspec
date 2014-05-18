# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ls_linkdirect_api/version'

Gem::Specification.new do |spec|
  spec.name          = "ls_linkdirect_api"
  spec.version       = LsLinkdirectAPI::VERSION
  spec.authors       = ["Kirk Jarvis"]
  spec.email         = ["zuuzlo@yahoo.com"]
  spec.summary       = %q{Ruby wrapper for accessing Linkshare LinkLocator Direct API using REST. }
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "addressable", "~> 2.3.5"
  spec.add_dependency "htmlentities", "~> 4.3.1"
  spec.add_dependency "httparty", "~> 0.11.0"
  spec.add_dependency "recursive-open-struct", "~> 0.4.3"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
end
