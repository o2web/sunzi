# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'sunzi_rails'
  spec.version       = '0.0.1' # retrieve this value by: Gem.loaded_specs['sunzi'].version.to_s
  spec.authors       = ['Kenn Ejima', 'Patrice Lebel']
  spec.email         = ['kenn.ejima@gmail.com']
  spec.homepage      = 'http://github.com/o2web/sunzi'
  spec.summary       = %q{Server provisioning utility for minimalists}
  spec.description   = %q{Server provisioning utility for minimalists}
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'rainbow'
  spec.add_runtime_dependency 'net-ssh'
  spec.add_runtime_dependency 'capistrano', '~> 3.1'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
