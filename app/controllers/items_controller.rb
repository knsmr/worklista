class ItemsController < ApplicationController
  before_filter :authorise_as_owner, :except => [:index, :show, :tag]
  before_filter :find_item, :except => [:create, :index, :tag]
  respond_to :html, :xml, :json

  def create
    @item = @user.items.new(params[:item])
    @item.interval = 180
    @item.url_normalize
    success = false
    error = ""
    if @item.load
      success = true
      @user.last_item_updated_at = Time.now; @user.save
      respond_to do |format|
        format.html do
          if request.xhr?
            render :partial => "users/item", :locals => {:i => @item, :user => @user}, :layout => false, :status => :created
          else
            redirect_to edit_user_item_path(current_user, @item)
          end
        end
      end
    else
      error = "Invalid URL!"
    end
  rescue Timeout::Error
    error = "Timeout! Could not retrieve data from the URL!!"
  rescue SocketError
    error = "There's no such URL!!"
  rescue OpenURI::HTTPError
    error = "Couldn't find the page!!"
  rescue
    error = "Not valid"
  ensure
    unless success
      respond_with do |format|
        format.html do
          if request.xhr?
            render :text => error, :status => 404
          else
            redirect_to user_recent_path(current_user.username)
          end
        end
      end
    end
  end

  def show
    @user = User.find(params[:user_id])
  end

  def destroy
    @item.destroy

    respond_to do |format|
      format.html do
        flash[:notice] = "Successfully destroyed an item."
        redirect_to user_recent_path(current_user.username)
      end
      format.js
    end
  end

  def update
    if @item.fetch && @item.update_attributes(params[:item]) 
      flash[:notice] = "Successfully updated item."
      redirect_to user_item_path(@user, @item)
    else
      render :action => 'edit'
    end
  end

  def toggle_pick
    if @item.toggle_pick_if_the_number_of_picks_doesnt_exceed_the_limit
      pick_state = @item.pick? ? "picked" : "unpicked"
      flash[:notice] = "Successfully #{pick_state} item."
    else
      flash[:error] = "Can't pick more than 10 items."
    end
    redirect_to user_pickup_path(current_user.username)
  end

  def index
    @items = Item.order("published_at DESC").page params[:page]
  end

  def tag
    @items = Item.order("published_at DESC").tagged(params[:tag]).page params[:page]
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
  def find_item; @item = Item.find(params[:id])
    if @item.user_id != params[:user_id].to_i
      raise ActiveRecord::RecordNotFound
    end
  rescue ActiveRecord::RecordNotFound
    # need to create 404 page
    render :text => "Not found"
  end
end
