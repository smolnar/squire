require 'benchmark'
require_relative './setup'

Benchmark.bmbm do |x|
  x.report('Squire' )             { 100.times { |n| SquireTest.send("key_#{n}") } }
  x.report('Settingslogic')       { 100.times { |n| SettingslogicTest.send("key_#{n}") } }
end
