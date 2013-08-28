module Squire
  class Settings
    RESERVED = [:get_value, :to_hash]

    def initialize(path = nil, parent = nil)
      @path     = path
      @table    = Hash.new
      @parent   = parent
      @children = Array.new
    end

    def method_missing(method, *args, &block)
      _, key, type = *method.to_s.match(/(?<key>\w+)(?<type>[?=]{0,1})/)

      key = key.to_sym

      if block_given?
        if @table[key]
          config = @table[key]
        else
          config = Settings.new(@path ? "#{@path}.#{key}" : key, self)

          @table[key] = config
          @children << config
        end

        block.arity == 0 ? config.instance_eval(&block) : block.call(config)
      elsif args.count == 1
        @table[key] = args.pop

        define_key_accessor(key)
      elsif type == '?'
        !!get_value(key)
      else
        value = get_value(key)

        unless value
          raise MissingSettingError.new("Missing setting in '#{key}' in '#{@path}'.")
        end

        define_key_accessor(key) unless repond_to?(key)

        value
      end
    end

    def get_value(key)
      return @table[key] if @table[key]
      return @parent.get_value(key) if @parent
    end

    def to_hash
      result = Hash.new

      @table.each do |key, value|
        if value.is_a? Settings
          value = value.to_hash
        end

        result[key] = value
      end

      result
    end

    def self.from_hash(hash, parent = nil)
      result = Settings.new

      hash.each_pair do |key, value|
        if value.is_a? Hash
          value = from_hash(value, result)
        end

        result.send(key, value)
      end

      result
    end

    private

    def define_key_accessor(key)
      define_singleton_method(key) { get_value(key) } if key =~ /\A\w+\z/
    end
  end
end
