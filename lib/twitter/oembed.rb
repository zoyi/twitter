require 'twitter/base'

module TwitterAPI
  class OEmbed < TwitterAPI::Base
    attr_reader :author_name, :author_url, :cache_age, :height, :html,
      :provider_name, :provider_url, :type, :url, :version, :width
  end
end
