require 'twitter/base'
require 'twitter/creatable'

module TwitterAPI
  module Action
    class Tweet < TwitterAPI::Base
      include TwitterAPI::Creatable
      attr_reader :max_position, :min_position

      # @return [Array<TwitterAPI::User>]
      def sources
        @sources = Array(@attrs[:sources]).map do |user|
          TwitterAPI::User.fetch_or_new(user)
        end
      end

    end
    Status = Tweet
  end
end
