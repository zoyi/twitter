require 'twitter/base'
require 'twitter/creatable'

module TwitterAPI
  module Action
    class Mention < TwitterAPI::Base
      include TwitterAPI::Creatable
      attr_reader :max_position, :min_position

      # A collection of users who mentioned a user
      #
      # @return [Array<TwitterAPI::User>]
      def sources
        @sources = Array(@attrs[:sources]).map do |user|
          TwitterAPI::User.fetch_or_new(user)
        end
      end

      # The user who mentioned a user
      #
      # @return [TwitterAPI::User]
      def source
        @source = sources.first
      end

      # A collection of tweets that mention a user
      #
      # @return [Array<TwitterAPI::Tweet>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |tweet|
          TwitterAPI::Tweet.fetch_or_new(tweet)
        end
      end

      # A collection containing the mentioned user
      #
      # @return [Array<TwitterAPI::User>]
      def targets
        @targets = Array(@attrs[:targets]).map do |user|
          TwitterAPI::User.fetch_or_new(user)
        end
      end

    end
  end
end
