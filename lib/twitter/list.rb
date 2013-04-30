require 'twitter/creatable'
require 'twitter/identity'

module TwitterAPI
  class List < TwitterAPI::Identity
    include TwitterAPI::Creatable
    attr_reader :description, :following, :full_name, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri

    # @return [TwitterAPI::User]
    def user
      @user ||= TwitterAPI::User.fetch_or_new(@attrs[:user])
    end

  end
end
