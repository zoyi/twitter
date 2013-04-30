require 'helper'

describe TwitterAPI::ActionFactory do

  describe ".new" do
    it "generates a Favorite" do
      action = TwitterAPI::ActionFactory.fetch_or_new(:action => 'favorite')
      expect(action).to be_a TwitterAPI::Action::Favorite
    end
    it "generates a Follow" do
      action = TwitterAPI::ActionFactory.fetch_or_new(:action => 'follow')
      expect(action).to be_a TwitterAPI::Action::Follow
    end
    it "generates a ListMemberAdded" do
      action = TwitterAPI::ActionFactory.fetch_or_new(:action => 'list_member_added')
      expect(action).to be_a TwitterAPI::Action::ListMemberAdded
    end
    it "generates a Mention" do
      action = TwitterAPI::ActionFactory.fetch_or_new(:action => 'mention')
      expect(action).to be_a TwitterAPI::Action::Mention
    end
    it "generates a Reply" do
      action = TwitterAPI::ActionFactory.fetch_or_new(:action => 'reply')
      expect(action).to be_a TwitterAPI::Action::Reply
    end
    it "generates a Retweet" do
      action = TwitterAPI::ActionFactory.fetch_or_new(:action => 'retweet')
      expect(action).to be_a TwitterAPI::Action::Retweet
    end
    it "raises an ArgumentError when action is not specified" do
      expect{TwitterAPI::ActionFactory.fetch_or_new}.to raise_error ArgumentError
    end
  end

end
