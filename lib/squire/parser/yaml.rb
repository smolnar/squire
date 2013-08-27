require 'yaml'

module Squire
  module Parser
    module YAML
      def self.parse(path)
        ::YAML::load_file(path)
      end
    end
  end
end
