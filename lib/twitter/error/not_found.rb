require 'twitter/error/client_error'

module TwitterAPI
  class Error
    # Raised when Twitter returns the HTTP status code 404
    class NotFound < TwitterAPI::Error::ClientError
      HTTP_STATUS_CODE = 404
    end
  end
end
