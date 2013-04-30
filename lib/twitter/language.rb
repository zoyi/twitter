require 'twitter/base'

module TwitterAPI
  class Language < TwitterAPI::Base
    attr_reader :code, :name, :status
  end
end
