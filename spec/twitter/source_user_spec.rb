require 'helper'

describe TwitterAPI::SourceUser do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      saved_search = TwitterAPI::SourceUser.new(:id => 1, :name => "foo")
      other = TwitterAPI::SourceUser.new(:id => 1, :name => "bar")
      expect(saved_search == other).to be_true
    end
    it "returns false when objects IDs are different" do
      saved_search = TwitterAPI::SourceUser.new(:id => 1)
      other = TwitterAPI::SourceUser.new(:id => 2)
      expect(saved_search == other).to be_false
    end
    it "returns false when classes are different" do
      saved_search = TwitterAPI::SourceUser.new(:id => 1)
      other = TwitterAPI::Identity.new(:id => 1)
      expect(saved_search == other).to be_false
    end
  end

end
