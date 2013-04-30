require 'twitter/factory'
require 'twitter/media/photo'

module TwitterAPI
  class MediaFactory < TwitterAPI::Factory

    # Instantiates a new media object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a :type key.
    # @return [TwitterAPI::Media]
    def self.fetch_or_new(attrs={})
      super(:type, TwitterAPI::Media, attrs)
    end

  end
end
