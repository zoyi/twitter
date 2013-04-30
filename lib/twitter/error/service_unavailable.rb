require 'twitter/error/server_error'

module TwitterAPI
  class Error
    # Raised when Twitter returns the HTTP status code 503
    class ServiceUnavailable < TwitterAPI::Error::ServerError
      HTTP_STATUS_CODE = 503
      MESSAGE = "(__-){ Twitter is over capacity."
    end
  end
end
