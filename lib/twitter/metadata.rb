require 'twitter/base'

module TwitterAPI
  class Metadata < TwitterAPI::Base
    attr_reader :result_type
  end
end
