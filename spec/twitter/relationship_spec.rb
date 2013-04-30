require 'helper'

describe TwitterAPI::Relationship do

  describe "#source" do
    it "returns a User when source is set" do
      source = TwitterAPI::Relationship.new(:relationship => {:source => {:id => 7505382}}).source
      expect(source).to be_a TwitterAPI::SourceUser
    end
    it "returns nil when source is not set" do
      source = TwitterAPI::Relationship.new(:relationship => {}).source
      expect(source).to be_nil
    end
  end

  describe "#target" do
    it "returns a User when target is set" do
      target = TwitterAPI::Relationship.new(:relationship => {:target => {:id => 7505382}}).target
      expect(target).to be_a TwitterAPI::TargetUser
    end
    it "returns nil when target is not set" do
      target = TwitterAPI::Relationship.new(:relationship => {}).target
      expect(target).to be_nil
    end
  end

  describe "#update" do
    it "updates a relationship" do
      relationship = TwitterAPI::Relationship.new(:relationship => {:target => {:id => 7505382}})
      relationship.update(:relationship => {:target => {:id => 14100886}})
      expect(relationship.target.id).to eq 14100886
    end
  end

end
