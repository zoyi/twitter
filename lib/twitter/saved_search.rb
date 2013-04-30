require 'twitter/creatable'
require 'twitter/identity'

module TwitterAPI
  class SavedSearch < TwitterAPI::Identity
    include TwitterAPI::Creatable
    attr_reader :name, :position, :query
  end
end
