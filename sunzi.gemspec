# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sunzi/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= #{Sunzi::RUBY_VERSION}"

  spec.name          = 'sunzi-rails'
  spec.version       = Sunzi::VERSION
  spec.authors       = ['Kenn Ejima', 'Patrice Lebel']
  spec.email         = ['kenn.ejima@gmail.com']
  spec.homepage      = 'http://github.com/o2web/sunzi-rails'
  spec.summary       = %q{Server provisioning utility for minimalists}
  spec.description   = %q{Server provisioning utility for minimalists}
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["sunzi-cap"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', "~> #{Sunzi::RAILS_VERSION}", ">= #{Sunzi::RAILS_VERSION}.0"

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'rainbow'
  spec.add_runtime_dependency 'net-ssh'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
