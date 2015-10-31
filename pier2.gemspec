# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pier2/version'

Gem::Specification.new do |spec|
  spec.name          = "pier2"
  spec.version       = Pier2::VERSION
  spec.authors       = ["Wayne Walker"]
  spec.email         = ["wwalker@solid-constructs.com"]
  spec.summary       = "Pier2 creates wrapper classes for importing spreadsheet data into existing ActiveRecord classes"
  spec.description   = "Pier2 creates wrapper classes for importing spreadsheet data into existing ActiveRecord classes\n"
  spec.homepage      = "http://github.com/wwalker/peir2"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency "roo-xls"
  spec.add_dependency "roo", "~> 2.2"
  spec.add_dependency "activerecord"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "minitest", "~> 5.4", ">= 5.4.3"
end
