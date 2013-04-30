require 'twitter/error'

module TwitterAPI
  class Error
    # Inherit from KeyError when Ruby 1.8 compatibility is removed
    class IdentityMapKeyError < ::IndexError
    end
  end
end
