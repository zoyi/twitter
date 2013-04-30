require 'twitter/base'

module TwitterAPI
  class Relationship < TwitterAPI::Base

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [TwitterAPI::Relationship]
    def initialize(attrs={})
      @attrs = attrs[:relationship]
    end

    # @return [TwitterAPI::SourceUser]
    def source
      @source ||= TwitterAPI::SourceUser.fetch_or_new(@attrs[:source])
    end

    # @return [TwitterAPI::TargetUser]
    def target
      @target ||= TwitterAPI::TargetUser.fetch_or_new(@attrs[:target])
    end

    # Update the attributes of a Relationship
    #
    # @param attrs [Hash]
    # @return [TwitterAPI::Relationship]
    def update(attrs)
      @attrs.update(attrs[:relationship]) unless attrs[:relationship].nil?
      self
    end

  end
end
