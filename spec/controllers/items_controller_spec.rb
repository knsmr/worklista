require 'spec_helper'

describe ItemsController do
  include Devise::TestHelpers # to give your spec access to helpers

  before(:each) do
    @user = Factory(:user)
    @params = {
      :user_id => @user.id,
      :item => {:url => 'http://www.google.com'}
    }
    sign_in :user, @user
  end

  describe "#create" do
    it "should create new item" do
      expect{
        post :create, @params
      }.to change(Item, :count).by(1)
    end

    it "should redirect to edit page" do
      post :create, @params
      response.should redirect_to edit_user_item_path(@user, Item.last)
    end
    
    it "should assign variables" do
      post :create, @params
      flash[:notice].should == "Created an item. Any changes?"
      assigns[:user].should == @user
      assigns[:item].should_not be_nil
    end
  end
end
