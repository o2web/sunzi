# coding: utf-8

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.0"

  spec.name          = 'sunzi-rails'
  spec.version       = '0.2.3' # retrieve this value by: Gem.loaded_specs['sunzi'].version.to_s
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

  spec.add_dependency 'rails', "~> 4.2", ">= 4.2.0"

  spec.add_runtime_dependency 'bundler', '~> 1.3'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'rainbow'
  spec.add_runtime_dependency 'net-ssh'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
