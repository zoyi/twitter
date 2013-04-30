require 'twitter/error/forbidden'

module TwitterAPI
  class Error
    # Raised when a Tweet has already been favorited
    class AlreadyFavorited < TwitterAPI::Error
      MESSAGE = "You have already favorited this status"
    end
  end
end
