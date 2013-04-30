require 'twitter/base'

module TwitterAPI
  class ProfileBanner < TwitterAPI::Base

    # Returns an array of photo sizes
    #
    # @return [Array<TwitterAPI::Size>]
    def sizes
      @sizes ||= Array(@attrs[:sizes]).inject({}) do |object, (key, value)|
        object[key] = TwitterAPI::Size.fetch_or_new(value)
        object
      end
    end

  end
end
