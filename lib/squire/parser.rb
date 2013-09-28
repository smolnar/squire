module Squire
  module Parser
    ##
    # Creates parser based on provided +type+.
    def self.of(type)
      case type
      when :hash       then Hash
      when :yaml, :yml then YAML
      else raise Squire::UndefinedParserError.new("Undefined parser for #{type}.")
      end
    end
  end
end
