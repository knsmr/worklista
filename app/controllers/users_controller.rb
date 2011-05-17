class UsersController < ApplicationController
  before_filter :find_user, :except => [:index]

  def index
    @users = User.order("last_sign_in_at DESC")
  end

  def tag
    @tag = params[:tag]
    @items = @items.tagged(@tag).order("published_at DESC").page params[:page]
    @size = @items.size
    @select = :recent
    render "me"
  end

  def show
    @items = @items.order("published_at DESC").page params[:page]
    @select = :recent
    respond_to do |format|
      format.html { render "me"}
      format.atom
    end
  end

  def popular
    @items = @items.order("hatena DESC").page params[:page]
    @select = :popular
    render "me"
  end

  def pickup
    @items = @items.where({:pick => true}).order("published_at DESC").page params[:page]
    @size = @items.size
    @select = :pickup
    render "me"
  end

private

  def find_user
    @user  = User.where("username = ?", params[:username]).first
    if @user.nil?
      redirect_to root_path 
    else
      @items = Item.where({:user_id => @user.id})
      @size  = @items.size
    end
  end

end
