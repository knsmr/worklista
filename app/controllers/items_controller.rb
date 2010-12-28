
class ItemsController < ApplicationController
  before_filter :authorise_as_owner
  before_filter :find_item, :except => [:create]
 
  def create
    @item = @user.items.new(params[:item])
    if @item.load
      flash[:notice] = "Created an item. Any changes?"
      redirect_to edit_user_item_path(current_user, @item)
    else
      flash[:error] = "Invalid URL!!"
      redirect_to user_recent_path(current_user.username)
    end
  rescue Timeout::Error
    flash[:error] = "Timeout! Could not retrieve data from the URL!!"
    redirect_to user_recent_path(current_user.username)
  end

  def destroy
    @item.destroy
    flash[:notice] = "Successfully destroyed an item."
    redirect_to user_recent_path(current_user.username)
  end

  def edit; end

  def update
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated item."
      redirect_to user_recent_path(current_user.username)
    else
      render :action => 'edit'
    end
  end

private

  def authorise_as_owner
    @user = User.find(params[:user_id])
    unless owner?
      flash[:error] = "Oops, something went wrong!"
      redirect_to users_path
    end
  end
  
  def owner?; user_signed_in? && @user == current_user; end
  def find_item; @item = Item.find(params[:id]); end
end
