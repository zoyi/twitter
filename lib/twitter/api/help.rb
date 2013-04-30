require 'twitter/api/utils'
require 'twitter/configuration'
require 'twitter/language'

module TwitterAPI
  module API
    module Help
      include TwitterAPI::API::Utils

      # Returns the current configuration used by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/help/configuration
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::Configuration] Twitter's configuration.
      # @example Return the current configuration used by Twitter
      #   Twitter.configuration
      def configuration(options={})
        object_from_response(TwitterAPI::Configuration, :get, "/1.1/help/configuration.json", options)
      end

      # Returns the list of languages supported by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/help/languages
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<TwitterAPI::Language>]
      # @example Return the list of languages Twitter supports
      #   Twitter.languages
      def languages(options={})
        objects_from_response(TwitterAPI::Language, :get, "/1.1/help/languages.json", options)
      end

      # Returns {https://twitter.com/privacy Twitter's Privacy Policy}
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/help/privacy
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [String]
      # @example Return {https://twitter.com/privacy Twitter's Privacy Policy}
      #   Twitter.privacy
      def privacy(options={})
        get("/1.1/help/privacy.json", options)[:body][:privacy]
      end

      # Returns {https://twitter.com/tos Twitter's Terms of Service}
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/help/tos
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [String]
      # @example Return {https://twitter.com/tos Twitter's Terms of Service}
      #   Twitter.tos
      def tos(options={})
        get("/1.1/help/tos.json", options)[:body][:tos]
      end

    end
  end
end
