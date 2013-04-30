require 'twitter/base'

module TwitterAPI
  class Trend < TwitterAPI::Base
    attr_reader :events, :name, :promoted_content, :query, :url

    # @param other [TwitterAPI::Trend]
    # @return [Boolean]
    def ==(other)
      super || attr_equal(:name, other) || attrs_equal(other)
    end

  end
end
