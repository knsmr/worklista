require 'spec_helper'

describe Item do
  describe "#guess_date" do
    before(:each) do
      @item = Factory.build(:item)
    end
    describe "when document includes date" do
      it "should set published at from document" do
        @item.doc = '2010/09/13'
        @item.guess_date
        @item.published_at.should == Date.parse('2010/09/13')
      end
    end
    
    describe "when document does not includes date" do
      it "should set today's date" do
        @item.doc = ''
        @item.guess_date
        @item.published_at.should == Date.today
      end
    end
  end
end
