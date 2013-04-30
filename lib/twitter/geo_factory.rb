require 'twitter/factory'
require 'twitter/geo/point'
require 'twitter/geo/polygon'

module TwitterAPI
  class GeoFactory < TwitterAPI::Factory

    # Instantiates a new geo object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a :type key.
    # @return [TwitterAPI::Geo]
    def self.fetch_or_new(attrs={})
      super(:type, TwitterAPI::Geo, attrs)
    end

  end
end
