module Squire
  class Settings
    RESERVED = [:get_value, :to_hash]

    ##
    # Creates new settings with +path+ and +parent+.
    # For top level settings (usually namespace), the is no +parent+ or +path+ specified.
    def initialize(path = nil, parent = nil)
      @path     = path
      @table    = Hash.new
      @parent   = parent
      @children = Array.new
    end

    ##
    # Handles settting of values.
    #
    # == Examples
    # Setting a value:
    #   .value = 2
    #   .value   2
    #
    # Getting a value:
    #   .value # => 2
    #
    # Checking a value:
    #   .value? # => true
    #
    # If block provided, it yields +key+ as parent.
    #
    #   .value do |value|
    #     ...
    #   end
    #
    #   .value do
    #     ...
    #   end
    def method_missing(method, *args, &block)
      _, key, type = *method.to_s.match(/(?<key>\w+)(?<type>[?=]{0,1})/)

      key = key.to_sym

      if block_given?
        if @table[key]
          settings = @table[key]
        else
          settings = Settings.new(@path ? "#{@path}.#{key}" : key, self)

          set_value(key, settings)

          @children << settings
        end

        block.arity == 0 ? settings.instance_eval(&block) : block.call(settings)
      elsif args.count == 1
        set_value(key, args.pop)

        define_key_accessor(key)
      elsif type == '?'
        !!get_value(key)
      else
        value = get_value(key)

        if value.nil?
          raise MissingSettingError.new("Missing setting in '#{key}' in '#{@path}'.")
        end

        define_key_accessor(key) unless repond_to?(key)

        value
      end
    end

    ##
    # Returns a value for +key+ from settings table.
    #
    # Goes up in ancestor chain by +parent+ until reaches a top. So if you define settings like
    #   settings.a = 1
    # and ask for
    #   settings.nested.a
    # it returns +settings.a+.
    def get_value(key)
      return @table[key] unless @table[key].nil?
      return @parent.get_value(key) if @parent
    end

    ##
    # Sets a +value+ for +key+
    def set_value(key, value)
      @table[key] = value
    end

    ##
    # Dumps settings as hash.
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

    ##
    # Loads new settings from provided +hash+.
    def self.from_hash(hash, parent = nil)
      result = Settings.new

      hash.each_pair do |key, value|
        if value.is_a? Hash
          value = from_hash(value, result)
        end

        result.set_value(key, value)
      end

      result
    end

    private

    ##
    # Defines key accessor for +key+ for faster accessing of keys.
    def define_key_accessor(key)
      define_singleton_method(key) { get_value(key) } if key =~ /\A\w+\z/
    end
  end
end
