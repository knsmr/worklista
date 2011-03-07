class ItemsController < ApplicationController
  before_filter :authorise_as_owner, :except => [:index, :tag]
  before_filter :find_item, :except => [:create, :index, :tag]
 
  def create
    @item = @user.items.new(params[:item])
    @item.interval = 180
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
  rescue SocketError
    flash[:error] = "There's no such URL!!"
    redirect_to user_recent_path(current_user.username)
  rescue OpenURI::HTTPError
    flash[:error] = "404 Not Found!!"
    redirect_to user_recent_path(current_user.username)
  end

  def destroy
    @item.destroy
    flash[:notice] = "Successfully destroyed an item."
    redirect_to user_recent_path(current_user.username)
  end

  def update
    if @item.fetch && @item.update_attributes(params[:item]) 
      flash[:notice] = "Successfully updated item."
      redirect_to user_recent_path(current_user.username)
    else
      render :action => 'edit'
    end
  end

  def index
    @items = Item.order("published_at DESC").page params[:page]
  end

  def tag
    @items = Item.tagged(params[:tag]).page params[:page]
    render "index"
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
