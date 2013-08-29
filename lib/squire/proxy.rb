module Squire
  class Proxy
    include Squire::Base::ClassMethods

    def initialize(base)
      @base = base
    end
  end
end
