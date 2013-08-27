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

      unless @source.is_a? Hash
        @type = options[:type] || File.extname(@source)[1..-1].to_sym
      else
        @type = :hash
      end
    end

    def settings
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

      Squire::Settings.from_hash(hash)
    end

    def reload
      @settings = nil
    end
  end
end
