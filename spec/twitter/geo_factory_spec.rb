require 'helper'

describe TwitterAPI::GeoFactory do

  describe ".new" do
    it "generates a Point" do
      geo = TwitterAPI::GeoFactory.fetch_or_new(:type => 'Point')
      expect(geo).to be_a TwitterAPI::Geo::Point
    end
    it "generates a Polygon" do
      geo = TwitterAPI::GeoFactory.fetch_or_new(:type => 'Polygon')
      expect(geo).to be_a TwitterAPI::Geo::Polygon
    end
    it "raises an ArgumentError when type is not specified" do
      expect{TwitterAPI::GeoFactory.fetch_or_new}.to raise_error ArgumentError
    end
  end

end
