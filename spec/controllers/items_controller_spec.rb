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

      it "should render error" do
        post :create, @params
        response.should render_template('users/show')
        assigns[:item].errors[:url].should_not be_empty
      end
    end
  end
end
