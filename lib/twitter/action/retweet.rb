require 'twitter/action/tweet'

module TwitterAPI
  module Action
    class Retweet < TwitterAPI::Action::Tweet

      # A collection of retweets
      #
      # @return [Array<TwitterAPI::Tweet>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |tweet|
          TwitterAPI::Tweet.fetch_or_new(tweet)
        end
      end

      # A collection containing the retweeted user
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
