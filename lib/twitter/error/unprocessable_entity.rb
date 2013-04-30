require 'twitter/error/client_error'

module TwitterAPI
  class Error
    # Raised when Twitter returns the HTTP status code 404
    class UnprocessableEntity < TwitterAPI::Error::ClientError
      HTTP_STATUS_CODE = 422
    end
  end
end
