
class ItemsController < ApplicationController
  before_filter :authorise_as_owner
 
  def create
    @item = @user.items.new(params[:item])
    unless @item.valid?
      flash[:notice] = "Invalid URL!!"
      return redirect_to user_recent_path(current_user.username)
    end

    begin
      @doc = @item.fetch
    rescue Timeout::Error
      flash[:notice] = "Timeout! Could not retrieve data from the URL!!"
      return redirect_to user_recent_path(current_user.username)
    end

    if @item.save
      flash[:notice] = "Created an item. Any changes?"
      redirect_to edit_user_item_path(current_user, @item)
    else
      render :action => 'new'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed an item."
    redirect_to user_recent_path(current_user.username)
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
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
      flash[:notice] = "Oops, something went wrong!"
      redirect_to users_path
    end
  end
  
  def owner?; user_signed_in? && @user == current_user; end
end
