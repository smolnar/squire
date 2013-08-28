require 'yaml'

module Squire
  module Parser
    module YAML
      def self.parse(path)
        ::YAML::load_file(path).deep_symbolize_keys
      end
    end
  end
end
