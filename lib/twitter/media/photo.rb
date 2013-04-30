require 'twitter/identity'

module TwitterAPI
  module Media
    class Photo < TwitterAPI::Identity
      attr_reader :display_url, :expanded_url, :indices, :media_url,
        :media_url_https, :url

      # Returns an array of photo sizes
      #
      # @return [Array<TwitterAPI::Size>]
      def sizes
        @sizes ||= Array(@attrs[:sizes]).inject({}) do |object, (key, value)|
          object[key] = TwitterAPI::Size.fetch_or_new(value)
          object
        end
      end

    end
  end
end
