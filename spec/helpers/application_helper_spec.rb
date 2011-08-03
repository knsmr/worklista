require 'spec_helper'

describe ApplicationHelper do
  before(:each) do
    @item = Factory.build(:item)
    @user = Factory.build(:user)
  end

  describe "#link_to_hatena" do
    it "returns a link to hatena" do
      link_to_hatena(@item.url).should == "http://b.hatena.ne.jp/entry/www.google.com"
    end
  end

  describe "#photo_tag" do
    describe "for twitter users" do
      before(:each) do
        @user.remote_photo_url = "http://a2.twimg.com/profile_images/425846032/ken-sushi.jpg"
        @user.provider = "twitter"
      end

      it "returns a proper link to the twitter icon image" do
        photo_tag(@user).should match /^<img.+http:\/\/a2.twimg.com\/profile_images\/425846032\/ken-sushi_bigger.jpg/
        photo_tag(@user).should match /height=\"73\"/
      end

      it "returns a proper link to the twitter small icon image" do
        photo_tag(@user, :size => :small).should match /^<img.+http:\/\/a2.twimg.com\/profile_images\/425846032\/ken-sushi_normal.jpg/
        photo_tag(@user, :size => :small).should match /height=\"24\"/
      end

      it "returns a proper link to the twitter big icon image" do
        photo_tag(@user, :size => :big).should match /^<img.+http:\/\/a2.twimg.com\/profile_images\/425846032\/ken-sushi.jpg/
        photo_tag(@user, :size => :big).should match /height=\"240\"/
      end
    end

    describe "for facebook users" do
      before(:each) do
        @user.remote_photo_url = "http://a2.twimg.com/profile_images/425846032/ken-sushi.jpg"
        @user.provider = "twitter"
      end

      it "returns a proper link to the twitter icon image" do
        photo_tag(@user).should match /^<img.+http:\/\/a2.twimg.com\/profile_images\/425846032\/ken-sushi_bigger.jpg/
        photo_tag(@user).should match /height=\"73\"/
      end

      it "returns a proper link to the twitter small icon image" do
        photo_tag(@user, :size => :small).should match /^<img.+http:\/\/a2.twimg.com\/profile_images\/425846032\/ken-sushi_normal.jpg/
        photo_tag(@user, :size => :small).should match /height=\"24\"/
      end

      it "returns a proper link to the twitter big icon image" do
        photo_tag(@user, :size => :big).should match /^<img.+http:\/\/a2.twimg.com\/profile_images\/425846032\/ken-sushi.jpg/
        photo_tag(@user, :size => :big).should match /height=\"240\"/
      end
    end
  end
end
