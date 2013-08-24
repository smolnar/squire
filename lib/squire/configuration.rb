module Squire
  module Configuration
    extend ActiveSupport::Concern

    module ClassMethods
      def config(&block)
        @config ||= Entry.new

        if block_given?
          block.arity == 0 ? @config.instance_eval(&block) : block.call(@config)
        end

        @config
      end
    end

    class Entry
      RESERVED = [:get_value, :to_hash]

      def initialize(parent = nil)
        @table    = Hash.new
        @parent   = parent
        @children = Array.new
      end

      def method_missing(method, *args, &block)
        _, name, type = *method.to_s.match(/(?<name>\w+)(?<type>[?=]{0,1})/)

        name = name.to_sym

        if block_given?
          if @table[name]
            config = @table[name]
          else
            config = Entry.new(self)

            @table[name] = config
            @children << config
          end

          block.arity == 0 ? config.instance_eval(&block) : block.call(config)
        elsif args.count == 1
          @table[name] = args.pop
        elsif type == '?'
          !!get_value(name)
        else
          value = get_value(name)

          value.nil? ? super(method, *args, &block) : value
        end
      end

      def get_value(name)
        return @table[name] if @table[name]
        return @parent.get_value(name) if @parent
      end

      def to_hash
        result = Hash.new

        @table.each do |key, value|
          if value.is_a? Entry
            value = value.to_hash
          end

          result[key] = value
        end

        result
      end
    end
  end
end
