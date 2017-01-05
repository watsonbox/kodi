# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kodi/version'

Gem::Specification.new do |spec|
  spec.name          = "kodi"
  spec.version       = Kodi::VERSION
  spec.authors       = ["Howard Wilson"]
  spec.email         = ["howard@watsonbox.net"]
  spec.summary       = %q{Ruby wrapper for Kodi JSON-RPC API}
  spec.description   = %q{Ruby wrapper for Kodi JSON-RPC API. See http://kodi.wiki/view/JSON-RPC_API/v6.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "webmock", "~> 1.20.4"
end
