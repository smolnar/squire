module Squire
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      def squire(&block)
        @squire ||= Squire::Configuration.new(self)

        if block_given?
          block.arity > 0 ? block.call(@squire) : @squire.instance_eval(&block)
        end

        @squire
      end

      def config(&block)
        squire.settings
      end

      def method_missing(method, *args, &block)
        config.send(method, *args, &block)
      end
    end
  end
end
