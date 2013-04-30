require 'helper'

describe TwitterAPI::Geo do

  before do
    @geo = TwitterAPI::Geo.new(:coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
  end

  describe "#==" do
    it "returns false for empty objects" do
      geo = TwitterAPI::Geo.new
      other = TwitterAPI::Geo.new
      expect(geo == other).to be_false
    end
    it "returns true when objects coordinates are the same" do
      other = TwitterAPI::Geo.new(:coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      expect(@geo == other).to be_true
    end
    it "returns false when objects coordinates are different" do
      other = TwitterAPI::Geo.new(:coordinates => [[[37.77752898, -122.40348192], [37.77752898, -122.387436], [37.79448597, -122.387436], [37.79448597, -122.40348192]]])
      expect(@geo == other).to be_false
    end
    it "returns false when classes are different" do
      other = TwitterAPI::Geo::Polygon.new(:coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      expect(@geo == other).to be_false
    end
  end

end
