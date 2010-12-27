require 'spec_helper'

describe ItemsController do
  include Devise::TestHelpers # to give your spec access to helpers

  before(:each) do
    @user = Factory(:user)
    @params = {
      :user_id => @user.id,
      :item => {:url => 'http://www.google.com'}
    }
  end

  describe "#create" do
    describe "when successful" do
      before(:each) do
        sign_in :user, @user
      end
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
    
    describe "when non author accessed" do
      before(:each) do
        different_user = Factory(:user)
        sign_in :user, different_user
      end
      it "should not create new item" do
        expect{
          post :create, @params
        }.to change(Item, :count).by(0)
      end

      it "should redirect to users page" do
        post :create, @params
        response.should redirect_to users_path
      end
    end

    describe "when invalid url is passed" do
      before(:each) do
        sign_in :user, @user
        @params[:item] = {:url => 'wrongurl'}
      end
      it "should not create new item" do
        expect{
          post :create, @params
        }.to change(Item, :count).by(0)
      end

      it "should redirect to users page" do
        post :create, @params
        response.should redirect_to user_recent_path(@user.username)
      end

      it "should assign variables" do
        post :create, @params
        flash[:notice].should == "Invalid URL!!"
      end
    end

    describe "when times out" do
      before(:each) do
        Timeout.should_receive(:timeout).and_raise(Timeout::Error)
        sign_in :user, @user
      end

      it "should not create new item" do
        expect{
          post :create, @params
        }.to change(Item, :count).by(0)
      end

      it "should redirect to users page" do
        post :create, @params
        response.should redirect_to user_recent_path(@user.username)
      end

      it "should assign variables" do
        post :create, @params
        flash[:notice].should == "Timeout! Could not retrieve data from the URL!!"
      end
    end
  end
end
