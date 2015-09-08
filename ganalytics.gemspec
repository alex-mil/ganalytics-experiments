# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ganalytics'

Gem::Specification.new do |gem|
  gem.authors       = ['Alex Milikovski']
  gem.email         = ['alexm33@gmail.com']
  gem.name          = 'ganalytics'
  gem.description   = 'Manage your Google Analytics A/B tests'
  gem.summary       = 'Manage your Google Analytics A/B tests'
  gem.homepage      = ''
  gem.license       = 'MIT'
  gem.version       = GAnalytics.version

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency(%q<httparty>, ['~> 0.13'])
end