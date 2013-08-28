require 'settingslogic'
require 'squire'
require 'yaml'
require 'benchmark'
require 'fileutils'

def generate_hash(number = 10000, nested = true)
  result = Hash.new

  number.times do |n|
    result["key_#{n}"] = nested ? generate_hash(1, false) : rand
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

puts <<-EOF
--------------------------------------------
Single access
--------------------------------------------

EOF

Benchmark.bmbm do |x|
  x.report('Squire' )       { 10000.times { |n| SquireTest.send("key_#{n}") } }
  x.report('Settingslogic') { 10000.times { |n| SettingslogicTest.send("key_#{n}") } }
end

SettingslogicTest.reload!
SquireTest.squire.reload!

puts <<-EOF
--------------------------------------------
Nested access
--------------------------------------------

EOF

Benchmark.bmbm do |x|
  x.report('Squire' )       { 10000.times { |n| SquireTest.send("key_#{n}").send("key_0") } }
  x.report('Settingslogic') { 10000.times { |n| SettingslogicTest.send("key_#{n}").send("key_0") } }
end

FileUtils.rm 'source.yml'
