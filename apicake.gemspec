lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apicake/version'

Gem::Specification.new do |s|
  s.name        = 'apicake'
  s.version     = APICake::VERSION
  s.date        = Date.today.to_s
  s.summary     = "API Building Toolkit"
  s.description = "Build Dynamic API Wrappers"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/apicake'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.0.0"

  s.add_runtime_dependency 'lightly', '~> 0.1'
  s.add_runtime_dependency 'httparty', '~> 0.14'

  s.add_development_dependency 'runfile', '~> 0.8'
  s.add_development_dependency 'runfile-tasks', '~> 0.4'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rdoc', '~> 5.0'
  s.add_development_dependency 'byebug', '~> 9.0'
  s.add_development_dependency 'simplecov', '~> 0.13'
  s.add_development_dependency 'require_all', '~> 1.4'
  s.add_development_dependency 'yard', '~> 0.8'
end
