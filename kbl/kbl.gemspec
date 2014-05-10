# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kbl/version'

Gem::Specification.new do |spec|
  spec.name          = "kbl"
  spec.version       = Kbl::VERSION
  spec.authors       = ["Yu-Cheng Chuang"]
  spec.email         = ["ducksteven@gmail.com"]
  spec.summary       = %q{KKBOX Playlist Builder}
  spec.description   = %q{Building KKBOX Playlist and serialize to KBL format.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '~> 1.6.1'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
