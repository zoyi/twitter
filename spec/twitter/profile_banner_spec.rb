require 'helper'

describe TwitterAPI::ProfileBanner do

  describe "#sizes" do
    it "returns a hash of Sizes when sizes is set" do
      sizes = TwitterAPI::ProfileBanner.new(:sizes => {:small => {:h => 226, :w => 340, :resize => 'fit'}, :large => {:h => 466, :w => 700, :resize => 'fit'}, :medium => {:h => 399, :w => 600, :resize => 'fit'}, :thumb => {:h => 150, :w => 150, :resize => 'crop'}}).sizes
      expect(sizes).to be_a Hash
      expect(sizes[:small]).to be_a TwitterAPI::Size
    end
  end

end
