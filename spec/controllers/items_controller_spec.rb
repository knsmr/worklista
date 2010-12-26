require 'spec_helper'

describe ItemsController do
  include Devise::TestHelpers # to give your spec access to helpers

  before(:each) do
    @user = Factory(:user)
    sign_in :user, @user
  end

  describe "#create" do
    it "should create new item" do
      expect{
        post :create,
             :user_id => @user.id,
             :item => {:url => 'http://www.google.com'}
      }.to change(Item, :count).by(1)
    end
  end
end
