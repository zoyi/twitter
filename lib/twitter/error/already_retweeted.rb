require 'twitter/error/forbidden'

module TwitterAPI
  class Error
    # Raised when a Tweet has already been retweeted
    class AlreadyRetweeted < TwitterAPI::Error
      MESSAGE = "sharing is not permissible for this status (Share validations failed)"
    end
  end
end
