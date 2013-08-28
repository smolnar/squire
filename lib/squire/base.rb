module Squire
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      ##
      # Return an object for configurating internal loading of settings
      # and setting a namespace, source, etc.
      #
      # == Examples
      #   squire.namespace 'namespace'
      #   squire.source 'file.yml'
      #   squire.reload!
      #
      # Accepts a block for more DSL-like way:
      #   squire do |squire|
      #     ...
      #   end
      #
      #   squire do
      #     namespace ...
      #   emd
      def squire(&block)
        @squire ||= Squire::Configuration.new

        if block_given?
          block.arity > 0 ? block.call(@squire) : @squire.instance_eval(&block)
        end

        @squire
      end

      ##
      # Return loaded configuration and settings
      #
      #   config.a # => 1
      #   config.b = 2
      def config(&block)
        squire.settings(&block)
      end

      ##
      # Serves as a bridge between config for
      # convenient calling of setting on class level.
      def method_missing(method, *args, &block)
        config.send(method, *args, &block)
      end
    end
  end
end
