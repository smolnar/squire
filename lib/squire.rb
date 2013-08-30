require 'active_support/concern'
require 'active_support/core_ext/hash/keys'
# require 'active_support/core_ext/hash/deep_merge'
require 'squire/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/except'
require 'squire/version'
require 'squire/exceptions'
require 'squire/parser/hash'
require 'squire/parser/yaml'
require 'squire/parser'
require 'squire/settings'
require 'squire/base'
require 'squire/proxy'
require 'squire/configuration'

module Squire
  extend ActiveSupport::Concern

  module ClassMethods
    def squire(&block)
      @squire_proxy ||= Proxy.new(self)

      @squire_proxy.squire(&block)
    end

    def config(&block)
      squire.config(&block)
    end
  end
end
