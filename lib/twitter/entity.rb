require 'twitter/base'

module TwitterAPI
  class Entity < TwitterAPI::Base
    attr_reader :indices
  end
end
