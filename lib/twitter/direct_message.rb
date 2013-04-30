require 'twitter/creatable'
require 'twitter/identity'

module TwitterAPI
  class DirectMessage < TwitterAPI::Identity
    include TwitterAPI::Creatable
    attr_reader :text
    alias full_text text

    # @return [TwitterAPI::User]
    def recipient
      @recipient ||= TwitterAPI::User.fetch_or_new(@attrs[:recipient])
    end

    # @return [TwitterAPI::User]
    def sender
      @sender ||= TwitterAPI::User.fetch_or_new(@attrs[:sender])
    end

  end
end
