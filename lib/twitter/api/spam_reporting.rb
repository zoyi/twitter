require 'twitter/api/utils'
require 'twitter/user'

module TwitterAPI
  module API
    module SpamReporting
      include TwitterAPI::API::Utils

      # The users specified are blocked by the authenticated user and reported as spammers
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/users/report_spam
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<TwitterAPI::User>] The reported users.
      # @overload report_spam(*users)
      #   @param users [Array<Integer, String, TwitterAPI::User>, Set<Integer, String, TwitterAPI::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Report @spam for spam
      #     TwitterAPI.report_spam("spam")
      #     TwitterAPI.report_spam(14589771) # Same as above
      # @overload report_spam(*users, options)
      #   @param users [Array<Integer, String, TwitterAPI::User>, Set<Integer, String, TwitterAPI::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def report_spam(*args)
        threaded_user_objects_from_response(:post, "/1.1/users/report_spam.json", args)
      end

    end
  end
end
