require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

requires 'mocks'

include APICake

Lightly.flush # for consistency

def fixture(filename, data = nil)
  if data
    File.write "spec/fixtures/#{filename}", data
    raise <<~MESSAGE
      Warning: Fixture data was written.
      This is perfectly fine if it was intended,
      but tests cannot proceed with it as a precaution.
    MESSAGE
  else
    File.read "spec/fixtures/#{filename}"
  end
end
