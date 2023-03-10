lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apicake/version'

Gem::Specification.new do |s|
  s.name        = 'apicake'
  s.version     = APICake::VERSION
  s.summary     = 'API Building Toolkit'
  s.description = 'Build Dynamic API Wrappers'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/apicake'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.7'

  s.add_runtime_dependency 'httparty', '~> 0.20'
  s.add_runtime_dependency 'lightly', '~> 0.3'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/apicake/issues',
    'source_code_uri'       => 'https://github.com/DannyBen/apicake',
    'rubygems_mfa_required' => 'true',
  }
end
