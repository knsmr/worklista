# -*- coding: utf-8 -*-
require 'spec_helper'

describe Item do
  before(:each) do
    @item = Factory.build(:item)
  end
  describe "published_at" do
    describe "when document includes date" do
      it "should set published at from document (1)" do
        @item.doc = '2010/09/13'
        @item.save!
        @item.published_at.should == Date.parse('2010/09/13')
      end

      it "should set published at from document (2)" do
        @item.doc = '2011-09-30'
        @item.save!
        @item.published_at.should == Date.parse('2011/09/30')
      end

      it "should set published at from document (3)" do
        @item.doc = '2010年9月3日'
        @item.save!
        @item.published_at.should == Date.parse('2010/09/03')
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
      it "should set title from document" do
        @item.doc = '<title>Hello</title>'
        @item.save!
        @item.title.should == 'Hello'
      end
    end

    describe "when title includes safe entity reference: raquo" do
      it "should set title from document" do
        @item.doc = '<title>&raquo; Hello &laquo;</title>'
        @item.save!
        @item.title.should == '» Hello «'
      end
    end

    describe "when title includes safe entity reference: rsquo" do
      it "should set title from document" do
        @item.doc = '<title>&lsquo; Hello &rsquo;</title>'
        @item.save!
        @item.title.should == '‘ Hello ’'
      end
    end

    describe "when title includes safe entity reference: quot" do
      it "should set title from document" do
        @item.doc = '<title>&quot; Hello &quot;</title>'
        @item.save!
        @item.title.should == '\' Hello \''
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

  describe "#url_normalize" do
    context "when the url is missing http:" do
      it "should add http" do
        @item.url = 'www.google.com'
        @item.url_normalize
        @item.url.should == 'http://www.google.com'
      end
    end

    context "when the input is a dirty amazon link", :am => true do
      amazon_links = { 
        'http://www.amazon.co.jp/%E3%83%A6%E3%83%8B%E3%82%B3%E3%83%BC%E3%83%89%E6%88%A6%E8%A8%98-%E2%94%80%E6%96%87%E5%AD%97%E7%AC%A6%E5%8F%B7%E3%81%AE%E5%9B%BD%E9%9A%9B%E6%A8%99%E6%BA%96%E5%8C%96%E3%83%90%E3%83%88%E3%83%AB-%E5%B0%8F%E6%9E%97%E9%BE%8D%E7%94%9F/dp/450154970X' => '450154970X',
        'http://www.amazon.co.jp/Coders-Work-%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E3%81%AE%E6%8A%80%E3%82%92%E3%82%81%E3%81%90%E3%82%8B%E6%8E%A2%E6%B1%82-Peter-Seibel/dp/4274068471/ref=pd_sim_b_1' => '4274068471',
        'http://www.amazon.co.jp/gp/product/4873114993/ref=s9_simh_gw_p14_d0_i3?pf_rd_m=AN1VRQENFRJN5&pf_rd_s=center-2&pf_rd_r=0HZSEGS2HN4WDGDD2FSA&pf_rd_t=101&pf_rd_p=463376756&pf_rd_i=489986' => '4873114993'
      }

      amazon_links.each do |url, id|
        it "should normalize the amazon item url" do
          @item.url = url.dup
          @item.url_normalize
          @item.url.should == "http://www.amazon.co.jp/dp/#{id}"
        end
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

  describe "#smart_update" do
    before(:each) do
      @item.url = 'http://www.google.com'
      @item.updated_at = 1.day.ago
      @item.interval = 180
      @item.hatena = 1
      @item.smart_update
    end
    it "should update hatena" do
      @item.hatena.should > 10
    end

    it "should not double the interval time" do
      @item.interval.should == 180
    end

    it "should quadruple the interval time for the second time" do
      @item.smart_update
      @item.interval.should == 180 * 8
    end

    it "should set bitly_url" do
      @item.bitly_url.should match(/bit.ly/)
    end

    it "should set retweet" do
      @item.retweet.should > 0
    end
  end

end
