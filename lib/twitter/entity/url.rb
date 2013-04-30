require 'twitter/entity'

module TwitterAPI
  class Entity
    class Url < TwitterAPI::Entity
      attr_reader :display_url, :expanded_url, :url
    end
  end
end
