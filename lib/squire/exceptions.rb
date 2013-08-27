module Squire
  class Error < StandardError; end
  class MissingSettingError < Squire::Error; end
  class UndefinedParserError < Squire::Error; end
end
