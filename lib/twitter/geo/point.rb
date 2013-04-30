require 'twitter/geo'

module TwitterAPI
  class Geo
    class Point < TwitterAPI::Geo

      # @return [Integer]
      def latitude
        coordinates[0]
      end
      alias lat latitude

      # @return [Integer]
      def longitude
        coordinates[1]
      end
      alias long longitude
      alias lng longitude

    end
  end
end
