require 'twitter/action/tweet'

module TwitterAPI
  module Action
    class Favorite < TwitterAPI::Action::Tweet
      attr_reader :target_objects

      # A collection containing the favorited tweet
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
