require 'twitter/entity'

module TwitterAPI
  class Entity
    class Hashtag < TwitterAPI::Entity
      attr_reader :text
    end
  end
end
