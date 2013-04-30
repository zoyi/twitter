require 'twitter/error'

module TwitterAPI
  class Error
    class ConfigurationError < ::ArgumentError
    end
  end
end
