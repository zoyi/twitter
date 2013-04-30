require 'twitter/base'

module TwitterAPI
  class Settings < TwitterAPI::Base
    attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone

    # @return [TwitterAPI::Place]
    def trend_location
      @trend_location ||= TwitterAPI::Place.fetch_or_new(Array(@attrs[:trend_location]).first)
    end

  end
end
