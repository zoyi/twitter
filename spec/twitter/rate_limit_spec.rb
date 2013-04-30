require 'helper'

describe TwitterAPI::RateLimit do

  describe "#limit" do
    it "returns an Integer when x-rate-limit-limit header is set" do
      rate_limit = TwitterAPI::RateLimit.new('x-rate-limit-limit' => "150")
      expect(rate_limit.limit).to be_an Integer
      expect(rate_limit.limit).to eq 150
    end
    it "returns nil when x-rate-limit-limit header is not set" do
      rate_limit = TwitterAPI::RateLimit.new
      expect(rate_limit.limit).to be_nil
    end
  end

  describe "#remaining" do
    it "returns an Integer when x-rate-limit-remaining header is set" do
      rate_limit = TwitterAPI::RateLimit.new('x-rate-limit-remaining' => "149")
      expect(rate_limit.remaining).to be_an Integer
      expect(rate_limit.remaining).to eq 149
    end
    it "returns nil when x-rate-limit-remaining header is not set" do
      rate_limit = TwitterAPI::RateLimit.new
      expect(rate_limit.remaining).to be_nil
    end
  end

  describe "#reset_at" do
    it "returns a Time when x-rate-limit-reset header is set" do
      rate_limit = TwitterAPI::RateLimit.new('x-rate-limit-reset' => "1339019097")
      expect(rate_limit.reset_at).to be_a Time
      expect(rate_limit.reset_at).to eq Time.at(1339019097)
    end
    it "returns nil when x-rate-limit-reset header is not set" do
      rate_limit = TwitterAPI::RateLimit.new
      expect(rate_limit.reset_at).to be_nil
    end
  end

  describe "#reset_in" do
    before do
      Timecop.freeze(Time.utc(2012, 6, 6, 17, 22, 0))
    end
    after do
      Timecop.return
    end
    it "returns an Integer when x-rate-limit-reset header is set" do
      rate_limit = TwitterAPI::RateLimit.new('x-rate-limit-reset' => "1339019097")
      expect(rate_limit.reset_in).to be_an Integer
      expect(rate_limit.reset_in).to eq 15777
    end
    it "returns nil when x-rate-limit-reset header is not set" do
      rate_limit = TwitterAPI::RateLimit.new
      expect(rate_limit.reset_in).to be_nil
    end
  end

  describe "#update" do
    before do
      Timecop.freeze(Time.utc(2012, 6, 6, 17, 22, 0))
    end
    after do
      Timecop.return
    end
    it "updates a rate limit" do
      rate_limit = TwitterAPI::RateLimit.new('x-rate-limit-reset' => "1339019097")
      expect(rate_limit.reset_in).to be_an Integer
      expect(rate_limit.reset_in).to eq 15777
      rate_limit.update({'x-rate-limit-reset' => "1339019098"})
      expect(rate_limit.reset_in).to be_an Integer
      expect(rate_limit.reset_in).to eq 15778
    end
  end

end
