require 'helper'

describe TwitterAPI::Action::Favorite do

  describe "#sources" do
    it "returns a collection of users who favorited a Tweet" do
      sources = TwitterAPI::Action::Favorite.new(:sources => [{:id => 7505382}]).sources
      expect(sources).to be_an Array
      expect(sources.first).to be_a TwitterAPI::User
    end
    it "is empty when not set" do
      sources = TwitterAPI::Action::Favorite.new.sources
      expect(sources).to be_empty
    end
  end

  describe "#targets" do
    it "returns a collection containing the favorited Tweet" do
      targets = TwitterAPI::Action::Favorite.new(:targets => [{:id => 25938088801}]).targets
      expect(targets).to be_an Array
      expect(targets.first).to be_a TwitterAPI::Tweet
    end
    it "is empty when not set" do
      targets = TwitterAPI::Action::Favorite.new.targets
      expect(targets).to be_empty
    end
  end

end
