require 'spec_helper'

describe Item do
  before(:each) do
    @item = Factory.build(:item)
  end
  describe "published_at" do
    describe "when document includes date" do
      it "should set published at from document" do
        @item.doc = '2010/09/13'
        @item.save!
        @item.published_at.should == Date.parse('2010/09/13')
      end
    end

    describe "when document does not includes date" do
      it "should set today's date" do
        @item.doc = ''
        @item.save!
        @item.published_at.should == Date.today
      end
    end
  end

  describe "title" do
    describe "when document includes title" do
      it "should set published at from document" do
        @item.doc = '<title>Hello</title>'
        @item.save!
        @item.title.should == 'Hello'
      end
    end

    describe "when document does not includes title" do
      it "should set url" do
        @item.url = 'http://www.google.com'
        @item.doc = 'no title'
        @item.save!
        @item.title.should == 'http://www.google.com'
      end
    end
  end

  describe "#fetch" do
    before(:each) do
      @item.url = 'http://www.google.com'
      @item.fetch
    end
    it "should set doc" do
      @item.doc.should_not be_nil
    end

    it "should set hatena" do
      @item.hatena.should > 0
    end

    it "should set bitly_url" do
      @item.bitly_url.should match(/bit.ly/)
    end

    it "should set retweet" do
      @item.retweet.should > 0
    end
  end
end
