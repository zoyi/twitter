require 'twitter/base'

module TwitterAPI
  class Geo < TwitterAPI::Base
    attr_reader :coordinates
    alias coords coordinates

    # @param other [TwitterAPI::Geo]
    # @return [Boolean]
    def ==(other)
      super || attr_equal(:coordinates, other) || attrs_equal(other)
    end

  end
end
