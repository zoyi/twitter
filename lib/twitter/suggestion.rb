require 'twitter/base'

module TwitterAPI
  class Suggestion < TwitterAPI::Base
    attr_reader :name, :size, :slug

    # @param other [TwitterAPI::Suggestion]
    # @return [Boolean]
    def ==(other)
      super || attr_equal(:slug, other) || attrs_equal(other)
    end

    # @return [Array<TwitterAPI::User>]
    def users
      @users ||= Array(@attrs[:users]).map do |user|
        TwitterAPI::User.fetch_or_new(user)
      end
    end

  end
end
