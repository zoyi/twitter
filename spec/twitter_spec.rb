require 'helper'

describe Twitter do

  after do
    TwitterAPI.reset!
  end

  context "when delegating to a client" do

    before do
      stub_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      TwitterAPI.user_timeline('sferik')
      expect(a_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"})).to have_been_made
    end

    it "returns the same results as a client" do
      expect(TwitterAPI.user_timeline('sferik')).to eq TwitterAPI::Client.new.user_timeline('sferik')
    end

  end

  describe ".respond_to?" do
    it "delegates to TwitterAPI::Client" do
      expect(TwitterAPI.respond_to?(:user)).to be_true
    end
    it "takes an optional argument" do
      expect(TwitterAPI.respond_to?(:client, true)).to be_true
    end
  end

  describe ".client" do
    it "returns a TwitterAPI::Client" do
      expect(TwitterAPI.client).to be_a TwitterAPI::Client
    end

    context "when the options don't change" do
      it "caches the client" do
        expect(TwitterAPI.client).to eq TwitterAPI.client
      end
    end
    context "when the options change" do
      it "busts the cache" do
        client1 = TwitterAPI.client
        TwitterAPI.configure do |config|
          config.consumer_key = 'abc'
          config.consumer_secret = '123'
        end
        client2 = TwitterAPI.client
        expect(client1).not_to eq client2
      end
    end
  end

  describe ".configure" do
    TwitterAPI::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        TwitterAPI.configure do |config|
          config.send("#{key}=", key)
        end
        expect(TwitterAPI.instance_variable_get(:"@#{key}")).to eq key
      end
    end

    context "when invalid credentials are provided" do
      it "raises a ConfigurationError exception" do
        expect {
          TwitterAPI.configure do |config|
            config.consumer_key = [12345, 54321]
            config.consumer_secret = 'valid_data'
          end
        }.to raise_exception(TwitterAPI::Error::ConfigurationError)
      end
    end

    context "when no credentials are provided" do
      it "does not raise an exception" do
        expect {
          TwitterAPI.configure do |config|
            config.consumer_key = nil
            config.consumer_secret = nil
            config.oauth_token = nil
            config.oauth_token_secret = nil
          end
        }.to_not raise_exception(TwitterAPI::Error::ConfigurationError)
      end
    end
  end

  describe ".credentials?" do
    it "returns true if all credentials are present" do
      TwitterAPI.configure do |config|
        config.consumer_key = 'CK'
        config.consumer_secret = 'CS'
        config.oauth_token = 'OT'
        config.oauth_token_secret = 'OS'
      end
      expect(TwitterAPI.credentials?).to be_true
    end
    it "returns false if any credentials are missing" do
      TwitterAPI.configure do |config|
        config.consumer_key = 'CK'
        config.consumer_secret = 'CS'
        config.oauth_token = 'OT'
      end
      expect(TwitterAPI.credentials?).to be_false
    end
  end

end
