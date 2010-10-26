class ItemsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @item = @user.items.create(params[:item])
    redirect_to me_path
  end
end
