lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
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
  s.required_ruby_version = ">= 2.2.2"

  s.add_runtime_dependency 'lightly', '~> 0.1'
  s.add_runtime_dependency 'httparty', '~> 0.14'
end
