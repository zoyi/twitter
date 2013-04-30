require 'twitter/basic_user'

module TwitterAPI
  class TargetUser < TwitterAPI::BasicUser
    attr_reader :followed_by
  end
end
