module Squire
  class Configuration
    attr_accessor :namespace,
                  :base_namespace,
                  :source,
                  :type

    def namespace(namespace = nil, options = {})
      return @namespace unless namespace

      @namespace      = namespace if namespace
      @base_namespace = options[:base] if options[:base]
    end

    def source(source = nil, options = {})
      return @source unless source

      @source = source
      @parser = options[:parser]
      @type   = options[:type]

      @type ||= source.is_a?(Hash) ? :hash : File.extname(@source)[1..-1].to_sym
    end

    def settings(&block)
      @settings ||= setup

      settings = @namespace ? @settings.send(@namespace) : @settings

      if block_given?
        block.arity == 0 ? settings.instance_eval(&block) : block.call(settings)
      end

      settings
    end

    alias :config :settings

    def setup
      return Squire::Setting.new unless @source

      parser = Squire::Parser.of(@type)

      hash = parser.parse(source)

      if base_namespace
        hash.except(base_namespace).each do |key, values|
          values.deep_merge!(hash[base_namespace])
        end
      end

      Squire::Settings.from_hash(hash)
    end

    def reload!
      @settings = nil
    end
  end
end
