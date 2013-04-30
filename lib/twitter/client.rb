require 'faraday'
require 'multi_json'
require 'twitter/api/direct_messages'
require 'twitter/api/favorites'
require 'twitter/api/friends_and_followers'
require 'twitter/api/help'
require 'twitter/api/lists'
require 'twitter/api/places_and_geo'
require 'twitter/api/saved_searches'
require 'twitter/api/search'
require 'twitter/api/spam_reporting'
require 'twitter/api/suggested_users'
require 'twitter/api/timelines'
require 'twitter/api/trends'
require 'twitter/api/tweets'
require 'twitter/api/undocumented'
require 'twitter/api/users'
require 'twitter/configurable'
require 'twitter/error/client_error'
require 'twitter/error/decode_error'
require 'simple_oauth'
require 'uri'

module TwitterAPI
  # Wrapper for the Twitter REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {http://dev.twitter.com/doc the Twitter API Documentation}.
  # @see http://dev.twitter.com/pages/every_developer
  class Client
    include TwitterAPI::API::DirectMessages
    include TwitterAPI::API::Favorites
    include TwitterAPI::API::FriendsAndFollowers
    include TwitterAPI::API::Help
    include TwitterAPI::API::Lists
    include TwitterAPI::API::PlacesAndGeo
    include TwitterAPI::API::SavedSearches
    include TwitterAPI::API::Search
    include TwitterAPI::API::SpamReporting
    include TwitterAPI::API::SuggestedUsers
    include TwitterAPI::API::Timelines
    include TwitterAPI::API::Trends
    include TwitterAPI::API::Tweets
    include TwitterAPI::API::Undocumented
    include TwitterAPI::API::Users
    include TwitterAPI::Configurable

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [TwitterAPI::Client]
    def initialize(options={})
      TwitterAPI::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || TwitterAPI.instance_variable_get(:"@#{key}"))
      end
    end

    # Perform an HTTP DELETE request
    def delete(path, params={})
      request(:delete, path, params)
    end

    # Perform an HTTP GET request
    def get(path, params={})
      request(:get, path, params)
    end

    # Perform an HTTP POST request
    def post(path, params={})
      signature_params = params.values.any?{|value| value.respond_to?(:to_io)} ? {} : params
      request(:post, path, params, signature_params)
    end

    # Perform an HTTP PUT request
    def put(path, params={})
      request(:put, path, params)
    end

  private

    def request(method, path, params={}, signature_params=params)
      connection.send(method.to_sym, path, params) do |request|
        request.headers[:authorization] = auth_header(method.to_sym, path, signature_params).to_s
      end.env
    rescue Faraday::Error::ClientError
      raise TwitterAPI::Error::ClientError
    rescue MultiJson::DecodeError
      raise TwitterAPI::Error::DecodeError
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

    def auth_header(method, path, params={})
      uri = URI(@endpoint + path)
      SimpleOAuth::Header.new(method, uri, params, credentials)
    end

  end
end
