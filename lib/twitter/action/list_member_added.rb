require 'twitter/base'
require 'twitter/creatable'

module TwitterAPI
  module Action
    class ListMemberAdded < TwitterAPI::Base
      include TwitterAPI::Creatable
      attr_reader :max_position, :min_position

      # A collection of users who added a user to a list
      #
      # @return [Array<TwitterAPI::User>]
      def sources
        @sources = Array(@attrs[:sources]).map do |user|
          TwitterAPI::User.fetch_or_new(user)
        end
      end

      # A collection of lists that were added to
      #
      # @return [Array<TwitterAPI::List>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |list|
          TwitterAPI::List.fetch_or_new(list)
        end
      end

      # A collection of users who were added to a list
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
