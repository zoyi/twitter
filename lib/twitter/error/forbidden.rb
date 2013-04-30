require 'twitter/error/client_error'

module TwitterAPI
  class Error
    # Raised when Twitter returns the HTTP status code 403
    class Forbidden < TwitterAPI::Error::ClientError
      HTTP_STATUS_CODE = 403
    end
  end
end
