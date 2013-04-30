require 'twitter/entity'

module TwitterAPI
  class Entity
    class UserMention < TwitterAPI::Entity
      attr_reader :id, :name, :screen_name
    end
  end
end
