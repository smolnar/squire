require 'active_support/concern'
require 'squire/version'
require 'squire/configuration'

module Squire
  extend ActiveSupport::Concern

  included do
    include Squire::Configuration
  end
end
