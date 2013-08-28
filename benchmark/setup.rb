require 'settingslogic'
require 'squire'
require 'yaml'
require 'ruby-prof'

def generate_hash(nested = true)
  result = Hash.new

  100.times do |n|
    result["key_#{n}"] = nested ? generate_hash(false) : rand
  end

  result
end

hash = generate_hash

File.open('source.yml', 'w') { |f| f.write({ 'development' => hash }.to_yaml) }

class SettingslogicTest < Settingslogic
  source 'source.yml'
  namespace 'development'
end

class SquireTest
  include Squire::Base

  squire.source 'source.yml'
  squire.namespace :development
end

