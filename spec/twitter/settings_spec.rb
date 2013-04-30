require 'helper'

describe TwitterAPI::Settings do

  describe "#trend_location" do
    it "returns a TwitterAPI::Place when set" do
      place = TwitterAPI::Settings.new(:trend_location => [{:countryCode => 'US', :name => 'San Francisco', :country => 'United States', :placeType => {:name => 'Town', :code => 7}, :woeid => 2487956, :parentid => 23424977, :url => 'http://where.yahooapis.com/v1/place/2487956'}])
      expect(place.trend_location).to be_a TwitterAPI::Place
    end
    it "returns nil when not set" do
      place = TwitterAPI::Settings.new
      expect(place.trend_location).to be_nil
    end
  end

end
