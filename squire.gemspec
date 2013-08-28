# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'squire/version'

Gem::Specification.new do |gem|
  gem.name          = 'squire'
  gem.version       = Squire::VERSION
  gem.authors       = ['Samuel Molnar']
  gem.email         = ['molnar.samuel@gmail.com']
  gem.description   = 'Your configuration squire.'
  gem.summary       = 'Squire handles your configuration per class/file by common config DSL and extensible source formats.'
  gem.homepage      = 'https://github.com/smolnar/squire'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '~> 4.0.0'

  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-debugger'
  gem.add_development_dependency 'fuubar'
  gem.add_development_dependency 'settingslogic'
  gem.add_development_dependency 'ruby-prof'
end
