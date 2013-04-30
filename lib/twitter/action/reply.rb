require 'twitter/action/tweet'

module TwitterAPI
  module Action
    class Reply < TwitterAPI::Action::Tweet

      # A collection of tweets that reply to a user
      #
      # @return [Array<TwitterAPI::Tweet>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |tweet|
          TwitterAPI::Tweet.fetch_or_new(tweet)
        end
      end

      # A collection that contains the replied-to tweets
      #
      # @return [Array<TwitterAPI::Tweet>]
      def targets
        @targets = Array(@attrs[:targets]).map do |tweet|
          TwitterAPI::Tweet.fetch_or_new(tweet)
        end
      end

    end
  end
end
