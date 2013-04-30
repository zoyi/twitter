require 'helper'

describe TwitterAPI::Suggestion do

  describe "#==" do
    it "returns false for empty objects" do
      suggestion = TwitterAPI::Suggestion.new
      other = TwitterAPI::Suggestion.new
      expect(suggestion == other).to be_false
    end
    it "returns true when objects slugs are the same" do
      suggestion = TwitterAPI::Suggestion.new(:slug => 1, :name => "foo")
      other = TwitterAPI::Suggestion.new(:slug => 1, :name => "bar")
      expect(suggestion == other).to be_true
    end
    it "returns false when objects slugs are different" do
      suggestion = TwitterAPI::Suggestion.new(:slug => 1)
      other = TwitterAPI::Suggestion.new(:slug => 2)
      expect(suggestion == other).to be_false
    end
    it "returns false when classes are different" do
      suggestion = TwitterAPI::Suggestion.new(:slug => 1)
      other = TwitterAPI::Base.new(:slug => 1)
      expect(suggestion == other).to be_false
    end
    it "returns true when objects non-slug attributes are the same" do
      suggestion = TwitterAPI::Suggestion.new(:name => "foo")
      other = TwitterAPI::Suggestion.new(:name => "foo")
      expect(suggestion == other).to be_true
    end
    it "returns false when objects non-slug attributes are different" do
      suggestion = TwitterAPI::Suggestion.new(:name => "foo")
      other = TwitterAPI::Suggestion.new(:name => "bar")
      expect(suggestion == other).to be_false
    end
  end

  describe "#users" do
    it "returns a User when user is set" do
      users = TwitterAPI::Suggestion.new(:users => [{:id => 7505382}]).users
      expect(users).to be_an Array
      expect(users.first).to be_a TwitterAPI::User
    end
    it "is empty when not set" do
      users = TwitterAPI::Suggestion.new.users
      expect(users).to be_empty
    end
  end

end
