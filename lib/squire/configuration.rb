module Squire
  class Configuration
    attr_accessor :base_namespace, :type

    ##
    # Sets and returns +namespace+.
    # If called without parameters, returns +namespace+.
    #
    # Possible options:
    # * <tt>:base</tt> - base namespace used for deep merging of values of other namespaces
    def namespace(namespace = nil, options = {})
      return @namespace unless namespace

      @namespace      = namespace.to_sym if namespace
      @base_namespace = options[:base].to_sym if options[:base]
    end

    ##
    # Sets +source+ for the configuration
    # If called without parameters, returns +source+.
    #
    # Possible options:
    # * <tt>:type</tt> - type of +source+ (optional, based on file extension)
    # * <tt>:parser</tt> - parse of input +source+ (optional, based on +:type+)
    def source(source = nil, options = {})
      return @source unless source

      @source = source
      @parser = options[:parser]
      @type   = options[:type]

      @type ||= source.is_a?(Hash) ? :hash : File.extname(@source)[1..-1].to_sym
    end

    ##
    # Loaded configuration stored in Settings class.
    # Accepts +block+ as parameter.
    #
    # == Examples
    #   settings do |settings|
    #     settings.a = 1
    #   end
    #
    #   settings do
    #     a 1
    #   end
    #
    #   settings.a = 1
    def settings(&block)
      @settings ||= setup

      settings = instance_variable_defined?(:@namespace) ? @settings.get_value(@namespace) : @settings

      if block_given?
        block.arity == 0 ? settings.instance_eval(&block) : block.call(settings)
      end

      settings
    end

    alias :config :settings

    ##
    # Sets up the configuration based on +namespace+ and +source+.
    # If +base_namespace+ provided, merges it's values with other namespaces for handling
    # nested overriding of values. 
    #
    # Favours values from +namespace+ over values from +base_namespace+.
    def setup
      return Squire::Settings.new unless @source

      parser = Squire::Parser.of(@type)

      hash = parser.parse(source).with_indifferent_access

      if base_namespace
        hash.except(base_namespace).each do |key, values|
          # favours value from namespace over value from defaults
          hash[key] = hash[base_namespace].deep_merge(values) { |_, default, value| value.nil? ? default : value }
        end
      end

      Squire::Settings.from_hash(hash)
    end

    ##
    # Reloads the +settings+.
    def reload!
      @settings = nil
    end
  end
end
