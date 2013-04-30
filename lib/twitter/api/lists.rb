require 'twitter/api/arguments'
require 'twitter/api/utils'
require 'twitter/core_ext/enumerable'
require 'twitter/cursor'
require 'twitter/error/forbidden'
require 'twitter/error/not_found'
require 'twitter/list'
require 'twitter/tweet'
require 'twitter/user'

module TwitterAPI
  module API
    module Lists
      include TwitterAPI::API::Utils
      MAX_USERS_PER_REQUEST = 100

      # Returns all lists the authenticating or specified user subscribes to, including their own
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/list
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<TwitterAPI::List>]
      # @overload lists(options={})
      #   @param options [Hash] A customizable set of options.
      #   @example Return all lists the authenticating user subscribes to
      #     TwitterAPI.lists
      # @overload lists(user, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Return all lists that @sferik subscribes to
      #     TwitterAPI.lists('sferik')
      #     TwitterAPI.lists(7505382)
      def lists(*args)
        objects_from_response_with_user(TwitterAPI::List, :get, "/1.1/lists/list.json", args)
      end
      alias lists_subscribed_to lists

      # Show tweet timeline for members of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/statuses
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<TwitterAPI::Tweet>]
      # @overload list_timeline(list, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count The number of results to retrieve.
      #   @example Show tweet timeline for members of the authenticated user's "presidents" list
      #     TwitterAPI.list_timeline('presidents')
      #     TwitterAPI.list_timeline(8863586)
      # @overload list_timeline(user, list, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count The number of results to retrieve.
      #   @example Show tweet timeline for members of @sferik's "presidents" list
      #     TwitterAPI.list_timeline('sferik', 'presidents')
      #     TwitterAPI.list_timeline('sferik', 8863586)
      #     TwitterAPI.list_timeline(7505382, 'presidents')
      #     TwitterAPI.list_timeline(7505382, 8863586)
      def list_timeline(*args)
        arguments = TwitterAPI::API::Arguments.new(args)
        merge_list!(arguments.options, arguments.pop)
        merge_owner!(arguments.options, arguments.pop || screen_name) unless arguments.options[:owner_id] || arguments.options[:owner_screen_name]
        objects_from_response(TwitterAPI::Tweet, :get, "/1.1/lists/statuses.json", arguments.options)
      end

      # Removes the specified member from the list
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/members/destroy
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The list.
      # @overload list_remove_member(list, user_to_remove, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
      #   @param options [Hash] A customizable set of options.
      #   @example Remove @BarackObama from the authenticated user's "presidents" list
      #     TwitterAPI.list_remove_member('presidents', 813286)
      #     TwitterAPI.list_remove_member('presidents', 'BarackObama')
      #     TwitterAPI.list_remove_member(8863586, 'BarackObama')
      # @overload list_remove_member(user, list, user_to_remove, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
      #   @param options [Hash] A customizable set of options.
      #   @example Remove @BarackObama from @sferik's "presidents" list
      #     TwitterAPI.list_remove_member('sferik', 'presidents', 813286)
      #     TwitterAPI.list_remove_member('sferik', 'presidents', 'BarackObama')
      #     TwitterAPI.list_remove_member('sferik', 8863586, 'BarackObama')
      #     TwitterAPI.list_remove_member(7505382, 'presidents', 813286)
      def list_remove_member(*args)
        list_from_response_with_user(:post, "/1.1/lists/members/destroy.json", args)
      end

      # List the lists the specified user has been added to
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/memberships
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::Cursor]
      # @overload memberships(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :filter_to_owned_lists When set to true, t or 1, will return just lists the authenticating user owns, and the user represented by user_id or screen_name is a member of.
      #   @example List the lists the authenticated user has been added to
      #     TwitterAPI.memberships
      # @overload memberships(user, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @option options [Boolean, String, Integer] :filter_to_owned_lists When set to true, t or 1, will return just lists the authenticating user owns, and the user represented by user_id or screen_name is a member of.
      #   @example List the lists that @sferik has been added to
      #     TwitterAPI.memberships('sferik')
      #     TwitterAPI.memberships(7505382)
      def memberships(*args)
        cursor_from_response_with_user(:lists, TwitterAPI::List, :get, "/1.1/lists/memberships.json", args, :memberships)
      end

      # Returns the subscribers of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/subscribers
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::Cursor] The subscribers of the specified list.
      # @overload list_subscribers(list, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the subscribers of the authenticated user's "presidents" list
      #     TwitterAPI.list_subscribers('presidents')
      #     TwitterAPI.list_subscribers(8863586)
      # @overload list_subscribers(user, list, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the subscribers of @sferik's "presidents" list
      #     TwitterAPI.list_subscribers('sferik', 'presidents')
      #     TwitterAPI.list_subscribers('sferik', 8863586)
      #     TwitterAPI.list_subscribers(7505382, 'presidents')
      def list_subscribers(*args)
        cursor_from_response_with_list(:get, "/1.1/lists/subscribers.json", args, :list_subscribers)
      end

      # Make the authenticated user follow the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/subscribers/create
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The specified list.
      # @overload list_subscribe(list, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Subscribe to the authenticated user's "presidents" list
      #     TwitterAPI.list_subscribe('presidents')
      #     TwitterAPI.list_subscribe(8863586)
      # @overload list_subscribe(user, list, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Subscribe to @sferik's "presidents" list
      #     TwitterAPI.list_subscribe('sferik', 'presidents')
      #     TwitterAPI.list_subscribe('sferik', 8863586)
      #     TwitterAPI.list_subscribe(7505382, 'presidents')
      def list_subscribe(*args)
        list_from_response(:post, "/1.1/lists/subscribers/create.json", args)
      end

      # Check if a user is a subscriber of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/subscribers/show
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      # @overload list_subscriber?(list, user_to_check, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param user_to_check [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Check if @BarackObama is a subscriber of the authenticated user's "presidents" list
      #     TwitterAPI.list_subscriber?('presidents', 813286)
      #     TwitterAPI.list_subscriber?(8863586, 813286)
      #     TwitterAPI.list_subscriber?('presidents', 'BarackObama')
      # @overload list_subscriber?(user, list, user_to_check, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param user_to_check [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
      #     TwitterAPI.list_subscriber?('sferik', 'presidents', 813286)
      #     TwitterAPI.list_subscriber?('sferik', 8863586, 813286)
      #     TwitterAPI.list_subscriber?(7505382, 'presidents', 813286)
      #     TwitterAPI.list_subscriber?('sferik', 'presidents', 'BarackObama')
      # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
      def list_subscriber?(*args)
        list_user?(:get, "/1.1/lists/subscribers/show.json", args)
      end

      # Unsubscribes the authenticated user form the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/subscribers/destroy
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The specified list.
      # @overload list_unsubscribe(list, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Unsubscribe from the authenticated user's "presidents" list
      #     TwitterAPI.list_unsubscribe('presidents')
      #     TwitterAPI.list_unsubscribe(8863586)
      # @overload list_unsubscribe(user, list, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Unsubscribe from @sferik's "presidents" list
      #     TwitterAPI.list_unsubscribe('sferik', 'presidents')
      #     TwitterAPI.list_unsubscribe('sferik', 8863586)
      #     TwitterAPI.list_unsubscribe(7505382, 'presidents')
      def list_unsubscribe(*args)
        list_from_response(:post, "/1.1/lists/subscribers/destroy.json", args)
      end

      # Adds specified members to a list
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/members/create_all
      # @note Lists are limited to having 500 members, and you are limited to adding up to 100 members to a list at a time with this method.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The list.
      # @overload list_add_members(list, users, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param users [Array<Integer, String, TwitterAPI::User>, Set<Integer, String, TwitterAPI::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @example Add @BarackObama and @pengwynn to the authenticated user's "presidents" list
      #     TwitterAPI.list_add_members('presidents', ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_add_members('presidents', [813286, 18755393])
      #     TwitterAPI.list_add_members(8863586, ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_add_members(8863586, [813286, 18755393])
      # @overload list_add_members(user, list, users, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param users [Array<Integer, String, TwitterAPI::User>, Set<Integer, String, TwitterAPI::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @example Add @BarackObama and @pengwynn to @sferik's "presidents" list
      #     TwitterAPI.list_add_members('sferik', 'presidents', ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_add_members('sferik', 'presidents', [813286, 18755393])
      #     TwitterAPI.list_add_members(7505382, 'presidents', ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_add_members(7505382, 'presidents', [813286, 18755393])
      #     TwitterAPI.list_add_members(7505382, 8863586, ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_add_members(7505382, 8863586, [813286, 18755393])
      def list_add_members(*args)
        list_from_response_with_users(:post, "/1.1/lists/members/create_all.json", args)
      end

      # Check if a user is a member of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/members/show
      # @authentication Requires user context
      # @rate_limited Yes
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean] true if user is a member of the specified list, otherwise false.
      # @overload list_member?(list, user_to_check, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @example Check if @BarackObama is a member of the authenticated user's "presidents" list
      #     TwitterAPI.list_member?('presidents', 813286)
      #     TwitterAPI.list_member?(8863586, 'BarackObama')
      # @overload list_member?(user, list, user_to_check, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
      #   @param options [Hash] A customizable set of options.
      #   @example Check if @BarackObama is a member of @sferik's "presidents" list
      #     TwitterAPI.list_member?('sferik', 'presidents', 813286)
      #     TwitterAPI.list_member?('sferik', 8863586, 'BarackObama')
      #     TwitterAPI.list_member?(7505382, 'presidents', 813286)
      def list_member?(*args)
        list_user?(:get, "/1.1/lists/members/show.json", args)
      end

      # Returns the members of the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/members
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::Cursor]
      # @overload list_members(list, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the members of the authenticated user's "presidents" list
      #     TwitterAPI.list_members('presidents')
      #     TwitterAPI.list_members(8863586)
      # @overload list_members(user, list, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the members of @sferik's "presidents" list
      #     TwitterAPI.list_members('sferik', 'presidents')
      #     TwitterAPI.list_members('sferik', 8863586)
      #     TwitterAPI.list_members(7505382, 'presidents')
      #     TwitterAPI.list_members(7505382, 8863586)
      def list_members(*args)
        cursor_from_response_with_list(:get, "/1.1/lists/members.json", args, :list_members)
      end

      # Add a member to a list
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/members/create
      # @note Lists are limited to having 500 members.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The list.
      # @overload list_add_member(list, user_to_add, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
      #   @param options [Hash] A customizable set of options.
      #   @example Add @BarackObama to the authenticated user's "presidents" list
      #     TwitterAPI.list_add_member('presidents', 813286)
      #     TwitterAPI.list_add_member(8863586, 813286)
      # @overload list_add_member(user, list, user_to_add, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
      #   @param options [Hash] A customizable set of options.
      #   @example Add @BarackObama to @sferik's "presidents" list
      #     TwitterAPI.list_add_member('sferik', 'presidents', 813286)
      #     TwitterAPI.list_add_member('sferik', 8863586, 813286)
      #     TwitterAPI.list_add_member(7505382, 'presidents', 813286)
      #     TwitterAPI.list_add_member(7505382, 8863586, 813286)
      def list_add_member(*args)
        list_from_response_with_user(:post, "/1.1/lists/members/create.json", args)
      end

      # Deletes the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/destroy
      # @note Must be owned by the authenticated user.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The deleted list.
      # @overload list_destroy(list, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Delete the authenticated user's "presidents" list
      #     TwitterAPI.list_destroy('presidents')
      #     TwitterAPI.list_destroy(8863586)
      # @overload list_destroy(user, list, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Delete @sferik's "presidents" list
      #     TwitterAPI.list_destroy('sferik', 'presidents')
      #     TwitterAPI.list_destroy('sferik', 8863586)
      #     TwitterAPI.list_destroy(7505382, 'presidents')
      #     TwitterAPI.list_destroy(7505382, 8863586)
      def list_destroy(*args)
        list_from_response(:post, "/1.1/lists/destroy.json", args)
      end

      # Updates the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/update
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The created list.
      # @overload list_update(list, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      #   @option options [String] :description The description to give the list.
      #   @example Update the authenticated user's "presidents" list to have the description "Presidents of the United States of America"
      #     TwitterAPI.list_update('presidents', :description => "Presidents of the United States of America")
      #     TwitterAPI.list_update(8863586, :description => "Presidents of the United States of America")
      # @overload list_update(user, list, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      #   @option options [String] :description The description to give the list.
      #   @example Update the @sferik's "presidents" list to have the description "Presidents of the United States of America"
      #     TwitterAPI.list_update('sferik', 'presidents', :description => "Presidents of the United States of America")
      #     TwitterAPI.list_update(7505382, 'presidents', :description => "Presidents of the United States of America")
      #     TwitterAPI.list_update('sferik', 8863586, :description => "Presidents of the United States of America")
      #     TwitterAPI.list_update(7505382, 8863586, :description => "Presidents of the United States of America")
      def list_update(*args)
        list_from_response(:post, "/1.1/lists/update.json", args)
      end

      # Creates a new list for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/create
      # @note Accounts are limited to 20 lists.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The created list.
      # @param name [String] The name for the list.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
      # @option options [String] :description The description to give the list.
      # @example Create a list named 'presidents'
      #   TwitterAPI.list_create('presidents')
      def list_create(name, options={})
        object_from_response(TwitterAPI::List, :post, "/1.1/lists/create.json", options.merge(:name => name))
      end

      # Show the specified list
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/show
      # @note Private lists will only be shown if the authenticated user owns the specified list.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The specified list.
      # @overload list(list, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Show the authenticated user's "presidents" list
      #     TwitterAPI.list('presidents')
      #     TwitterAPI.list(8863586)
      # @overload list(user, list, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param options [Hash] A customizable set of options.
      #   @example Show @sferik's "presidents" list
      #     TwitterAPI.list('sferik', 'presidents')
      #     TwitterAPI.list('sferik', 8863586)
      #     TwitterAPI.list(7505382, 'presidents')
      #     TwitterAPI.list(7505382, 8863586)
      def list(*args)
        list_from_response(:get, "/1.1/lists/show.json", args)
      end

      # List the lists the specified user follows
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/lists/subscriptions
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::Cursor]
      # @overload subscriptions(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example List the lists the authenticated user follows
      #     TwitterAPI.subscriptions
      # @overload subscriptions(user, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example List the lists that @sferik follows
      #     TwitterAPI.subscriptions('sferik')
      #     TwitterAPI.subscriptions(7505382)
      def subscriptions(*args)
        cursor_from_response_with_user(:lists, TwitterAPI::List, :get, "/1.1/lists/subscriptions.json", args, :subscriptions)
      end

      # Removes specified members from the list
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/lists/members/destroy_all
      # @rate_limited No
      # @authentication Requires user context
      # @raise [TwitterAPI::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [TwitterAPI::List] The list.
      # @overload list_remove_members(list, users, options={})
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param users [Array<Integer, String, TwitterAPI::User>, Set<Integer, String, TwitterAPI::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @example Remove @BarackObama and @pengwynn from the authenticated user's "presidents" list
      #     TwitterAPI.list_remove_members('presidents', ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_remove_members('presidents', [813286, 18755393])
      #     TwitterAPI.list_remove_members(8863586, ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_remove_members(8863586, [813286, 18755393])
      # @overload list_remove_members(user, list, users, options={})
      #   @param user [Integer, String, TwitterAPI::User] A Twitter user ID, screen name, or object.
      #   @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      #   @param users [Array<Integer, String, TwitterAPI::User>, Set<Integer, String, TwitterAPI::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @example Remove @BarackObama and @pengwynn from @sferik's "presidents" list
      #     TwitterAPI.list_remove_members('sferik', 'presidents', ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_remove_members('sferik', 'presidents', [813286, 18755393])
      #     TwitterAPI.list_remove_members(7505382, 'presidents', ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_remove_members(7505382, 'presidents', [813286, 18755393])
      #     TwitterAPI.list_remove_members(7505382, 8863586, ['BarackObama', 'pengwynn'])
      #     TwitterAPI.list_remove_members(7505382, 8863586, [813286, 18755393])
      def list_remove_members(*args)
        list_from_response_with_users(:post, "/1.1/lists/members/destroy_all.json", args)
      end

    private

      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<TwitterAPI::User>]
      def list_from_response(request_method, path, args)
        arguments = TwitterAPI::API::Arguments.new(args)
        merge_list!(arguments.options, arguments.pop)
        merge_owner!(arguments.options, arguments.pop || screen_name) unless arguments.options[:owner_id] || arguments.options[:owner_screen_name]
        object_from_response(TwitterAPI::List, request_method, path, arguments.options)
      end

      def cursor_from_response_with_list(request_method, path, args, calling_method)
        arguments = TwitterAPI::API::Arguments.new(args)
        merge_list!(arguments.options, arguments.pop)
        merge_owner!(arguments.options, arguments.pop || screen_name) unless arguments.options[:owner_id] || arguments.options[:owner_screen_name]
        cursor_from_response(:users, TwitterAPI::User, request_method, path, arguments.options, calling_method)
      end

      def list_user?(request_method, path, args)
        arguments = TwitterAPI::API::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop)
        merge_list!(arguments.options, arguments.pop)
        merge_owner!(arguments.options, arguments.pop || screen_name) unless arguments.options[:owner_id] || arguments.options[:owner_screen_name]
        send(request_method.to_sym, path, arguments.options)
        true
      rescue TwitterAPI::Error::NotFound, TwitterAPI::Error::Forbidden
        false
      end

      def list_from_response_with_user(request_method, path, args)
        arguments = TwitterAPI::API::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop)
        merge_list!(arguments.options, arguments.pop)
        merge_owner!(arguments.options, arguments.pop || screen_name) unless arguments.options[:owner_id] || arguments.options[:owner_screen_name]
        object_from_response(TwitterAPI::List, request_method, path, arguments.options)
      end

      def list_from_response_with_users(request_method, path, args)
        arguments = TwitterAPI::API::Arguments.new(args)
        members = arguments.pop
        merge_list!(arguments.options, arguments.pop)
        merge_owner!(arguments.options, arguments.pop || screen_name) unless arguments.options[:owner_id] || arguments.options[:owner_screen_name]
        members.flatten.each_slice(MAX_USERS_PER_REQUEST).threaded_map do |users|
          object_from_response(TwitterAPI::List, request_method, path, merge_users(arguments.options, users))
        end.last
      end

      # Take a list and merge it into the hash with the correct key
      #
      # @param hash [Hash]
      # @param list [Integer, String, TwitterAPI::List] A Twitter list ID, slug, or object.
      # @return [Hash]
      def merge_list!(hash, list)
        case list
        when Integer
          hash[:list_id] = list
        when String
          hash[:slug] = list
        when TwitterAPI::List
          hash[:list_id] = list.id
          merge_owner!(hash, list.user)
        end
        hash
      end

      # Take an owner and merge it into the hash with the correct key
      #
      # @param hash [Hash]
      # @param user[Integer, String, TwitterAPI::User] A Twitter user ID, screen_name, or object.
      # @return [Hash]
      def merge_owner!(hash, user)
        merge_user!(hash, user, "owner")
        hash[:owner_id] = hash.delete(:owner_user_id) unless hash[:owner_user_id].nil?
        hash
      end

    end
  end
end
