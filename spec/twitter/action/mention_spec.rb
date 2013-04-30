require 'helper'

describe TwitterAPI::Action::Mention do

  describe "#sources" do
    it "returns a collection of users who mentioned a user" do
      sources = TwitterAPI::Action::Mention.new(:sources => [{:id => 7505382}]).sources
      expect(sources).to be_an Array
      expect(sources.first).to be_a TwitterAPI::User
    end
    it "is empty when not set" do
      sources = TwitterAPI::Action::Mention.new.sources
      expect(sources).to be_empty
    end
  end

  describe "#source" do
    it "returns the user who mentioned a user" do
      source = TwitterAPI::Action::Mention.new(:sources => [{:id => 7505382}]).source
      expect(source).to be_a TwitterAPI::User
    end
    it "returns nil when not set" do
      source = TwitterAPI::Action::Mention.new.source
      expect(source).to be_nil
    end
  end

  describe "#target_objects" do
    it "returns a collection of Tweets that mention a user" do
      targets = TwitterAPI::Action::Mention.new(:target_objects => [{:id => 25938088801}]).target_objects
      expect(targets).to be_an Array
      expect(targets.first).to be_a TwitterAPI::Tweet
    end
    it "is empty when not set" do
      targets = TwitterAPI::Action::Mention.new.target_objects
      expect(targets).to be_empty
    end
  end

  describe "#targets" do
    it "returns a collection containing the mentioned user" do
      targets = TwitterAPI::Action::Mention.new(:targets => [{:id => 7505382}]).targets
      expect(targets).to be_an Array
      expect(targets.first).to be_a TwitterAPI::User
    end
    it "is empty when not set" do
      targets = TwitterAPI::Action::Mention.new.targets
      expect(targets).to be_empty
    end
  end

end
