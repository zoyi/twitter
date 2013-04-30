module TwitterAPI
  class Version
    MAJOR = 4 unless defined? TwitterAPI::Version::MAJOR
    MINOR = 6 unless defined? TwitterAPI::Version::MINOR
    PATCH = 0 unless defined? TwitterAPI::Version::PATCH
    PRE = nil unless defined? TwitterAPI::Version::PRE

    class << self

      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end
