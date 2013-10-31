require 'rubygems'
require 'bundler/setup'

require 'squire'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.expand_path(File.dirname(__FILE__)), "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Fixture
end
