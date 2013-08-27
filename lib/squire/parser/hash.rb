module Squire
  module Parser
    module Hash
      def self.parse(source)
        source.deep_symbolize_keys
      end
    end
  end
end
