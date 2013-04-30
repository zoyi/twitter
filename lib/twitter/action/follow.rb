require 'twitter/base'
require 'twitter/creatable'

module TwitterAPI
  module Action
    class Follow < TwitterAPI::Base
      include TwitterAPI::Creatable
      attr_reader :max_position, :min_position, :target_objects

      # A collection of users who followed a user
      #
      # @return [Array<TwitterAPI::User>]
      def sources
        @sources = Array(@attrs[:sources]).map do |user|
          TwitterAPI::User.fetch_or_new(user)
        end
      end

      # A collection containing the followed user
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
