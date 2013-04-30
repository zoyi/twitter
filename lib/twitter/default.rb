require 'faraday'
require 'faraday/request/multipart'
require 'twitter/configurable'
require 'twitter/error/client_error'
require 'twitter/error/server_error'
require 'twitter/request/multipart_with_file'
require 'twitter/response/parse_json'
require 'twitter/response/raise_error'
require 'twitter/version'

module TwitterAPI
  module Default
    ENDPOINT = 'https://api.twitter.com' unless defined? TwitterAPI::Default::ENDPOINT
    CONNECTION_OPTIONS = {
      :headers => {
        :accept => 'application/json',
        :user_agent => "Twitter Ruby Gem #{TwitterAPI::Version}",
      },
      :request => {
        :open_timeout => 5,
        :timeout => 10,
      },
      :ssl => {
        :verify => false
      },
    } unless defined? TwitterAPI::Default::CONNECTION_OPTIONS
    IDENTITY_MAP = false unless defined? TwitterAPI::Default::IDENTITY_MAP
    MIDDLEWARE = Faraday::Builder.new do |builder|
      # Convert file uploads to Faraday::UploadIO objects
      builder.use TwitterAPI::Request::MultipartWithFile
      # Checks for files in the payload
      builder.use Faraday::Request::Multipart
      # Convert request params to "www-form-urlencoded"
      builder.use Faraday::Request::UrlEncoded
      # Handle 4xx server responses
      builder.use TwitterAPI::Response::RaiseError, TwitterAPI::Error::ClientError
      # Parse JSON response bodies using MultiJson
      builder.use TwitterAPI::Response::ParseJson
      # Handle 5xx server responses
      builder.use TwitterAPI::Response::RaiseError, TwitterAPI::Error::ServerError
      # Set Faraday's HTTP adapter
      builder.adapter Faraday.default_adapter
    end unless defined? TwitterAPI::Default::MIDDLEWARE

    class << self

      # @return [Hash]
      def options
        Hash[TwitterAPI::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # @return [String]
      def consumer_key
        ENV['TWITTER_CONSUMER_KEY']
      end

      # @return [String]
      def consumer_secret
        ENV['TWITTER_CONSUMER_SECRET']
      end

      # @return [String]
      def oauth_token
        ENV['TWITTER_OAUTH_TOKEN']
      end

      # @return [String]
      def oauth_token_secret
        ENV['TWITTER_OAUTH_TOKEN_SECRET']
      end

      # @note This is configurable in case you want to use a Twitter-compatible endpoint.
      # @see http://status.net/wiki/Twitter-compatible_API
      # @see http://en.blog.wordpress.com/2009/12/12/twitter-api/
      # @see http://staff.tumblr.com/post/287703110/api
      # @see http://developer.typepad.com/typepad-twitter-api/twitter-api.html
      # @return [String]
      def endpoint
        ENDPOINT
      end

      def connection_options
        CONNECTION_OPTIONS
      end

      def identity_map
        IDENTITY_MAP
      end

      # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
      # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
      # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
      # @return [Faraday::Builder]
      def middleware
        MIDDLEWARE
      end

    end
  end
end
