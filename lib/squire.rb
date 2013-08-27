require 'active_support/concern'
require 'active_support/core_ext/hash/keys'
require 'squire/version'
require 'squire/exceptions'
require 'squire/parser/hash'
require 'squire/parser/yaml'
require 'squire/parser'
require 'squire/settings'
require 'squire/configuration'

module Squire
  extend ActiveSupport::Concern

  module ClassMethods
    def squire(&block)
      @squire_proxy ||= Squire::Proxy.new(self)

      @squire_proxy.squire(&block)
    end

    def config(&block)
      squire.config(&block)
    end
  end
end
