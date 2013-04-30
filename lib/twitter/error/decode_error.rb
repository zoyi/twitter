require 'twitter/error'

module TwitterAPI
  class Error
    # Raised when JSON parsing fails
    class DecodeError < TwitterAPI::Error
    end
  end
end
