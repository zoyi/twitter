require 'forwardable'
require 'twitter/creatable'
require 'twitter/exceptable'
require 'twitter/identity'

module TwitterAPI
  class Tweet < TwitterAPI::Identity
    extend Forwardable
    include TwitterAPI::Creatable
    include TwitterAPI::Exceptable
    attr_reader :favorited, :favoriters, :from_user_id, :from_user_name,
      :in_reply_to_screen_name, :in_reply_to_attrs_id, :in_reply_to_status_id,
      :in_reply_to_user_id, :lang, :repliers, :retweeted, :retweeters, :source,
      :text, :to_user, :to_user_id, :to_user_name, :truncated
    alias in_reply_to_tweet_id in_reply_to_status_id
    alias favourited favorited
    alias favourited? favorited?
    alias favouriters favoriters
    def_delegators :user, :profile_image_url, :profile_image_url_https

    # @return [Boolean]
    def entities?
      !@attrs[:entities].nil?
    end

    # @return [Integer]
    def favoriters_count
      favoriters_count = @attrs[:favoriters_count]
      favoriters_count.to_i if favoriters_count
    end
    alias favorite_count favoriters_count
    alias favorites_count favoriters_count
    alias favourite_count favoriters_count
    alias favourites_count favoriters_count
    alias favouriters_count favoriters_count

    # @return [String]
    def from_user
      @attrs[:from_user] || user && user.screen_name
    end

    def filter_level
      @attrs[:filter_level] || "none"
    end

    # @return [String]
    # @note May be > 140 characters.
    def full_text
      if retweeted_status
        prefix = text[/\A(RT @[a-z0-9_]{1,20}: )/i, 1]
        [prefix, retweeted_status.text].compact.join
      else
        text
      end
    end

    # @return [TwitterAPI::Geo]
    def geo
      @geo ||= TwitterAPI::GeoFactory.fetch_or_new(@attrs[:geo])
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<TwitterAPI::Entity::Hashtag>]
    def hashtags
      @hashtags ||= entities(TwitterAPI::Entity::Hashtag, :hashtags)
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<TwitterAPI::Media>]
    def media
      @media ||= entities(TwitterAPI::MediaFactory, :media)
    end

    # @return [TwitterAPI::Metadata]
    def metadata
      @metadata ||= TwitterAPI::Metadata.fetch_or_new(@attrs[:metadata])
    end

    # @return [TwitterAPI::Place]
    def place
      @place ||= TwitterAPI::Place.fetch_or_new(@attrs[:place])
    end

    # @return [Integer]
    def repliers_count
      repliers_count = @attrs[:repliers_count]
      repliers_count.to_i if repliers_count
    end
    alias reply_count repliers_count

    # @return [Boolean]
    def reply?
      !!in_reply_to_status_id
    end

    # @return [Boolean]
    def retweet?
      !!retweeted_status
    end

    # If this Tweet is a retweet, the original Tweet is available here.
    #
    # @return [TwitterAPI::Tweet]
    def retweeted_status
      @retweeted_status ||= self.class.fetch_or_new(@attrs[:retweeted_status])
    end
    alias retweeted_tweet retweeted_status
    alias retweet retweeted_status

    # @return [String]
    def retweeters_count
      retweeters_count = (@attrs[:retweet_count] || @attrs[:retweeters_count])
      retweeters_count.to_i if retweeters_count
    end
    alias retweet_count retweeters_count

    # @note Must include entities in your request for this method to work
    # @return [Array<TwitterAPI::Entity::Url>]
    def urls
      @urls ||= entities(TwitterAPI::Entity::Url, :urls)
    end

    # @return [TwitterAPI::User]
    def user
      @user ||= fetch_or_new_without_self(TwitterAPI::User, @attrs, :user, :status)
    end

    # @note Must include entities in your request for this method to work
    # @return [Array<TwitterAPI::Entity::UserMention>]
    def user_mentions
      @user_mentions ||= entities(TwitterAPI::Entity::UserMention, :user_mentions)
    end

    def user?
      !@attrs[:user].nil?
    end

  private

    # @param klass [Class]
    # @param key [Symbol]
    def entities(klass, key)
      if entities?
        Array(@attrs[:entities][key.to_sym]).map do |entity|
          klass.fetch_or_new(entity)
        end
      else
        warn "#{Kernel.caller.first}: To get #{key.to_s.tr('_', ' ')}, you must pass `:include_entities => true` when requesting the #{self.class.name}."
        []
      end
    end

  end

  Status = Tweet
end
