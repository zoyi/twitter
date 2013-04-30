require 'twitter/error/client_error'

module TwitterAPI
  class Error
    # Raised when Twitter returns the HTTP status code 429
    class TooManyRequests < TwitterAPI::Error::ClientError
      HTTP_STATUS_CODE = 429
    end
    EnhanceYourCalm = TooManyRequests
    RateLimited = TooManyRequests
  end
end
