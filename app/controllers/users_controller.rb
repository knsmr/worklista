class UsersController < ApplicationController
  before_filter :find_user, :except => [:index]

  def index
    @users = User.all
  end

  def tag
    @items.tagged(params[:tag]).page params[:page]

    @select = :recent
    render "me"
  end

  def show
    @items = @items.order("published_at DESC").page params[:page]
    @select = :recent
    render "me"
  end

  def popular
    @items = @items.order("hatena DESC").page params[:page]
    @select = :popular
    render "me"
  end

  def pickup
    @items = @items.where({:pick => true}).page params[:page]
    @select = :pickup
    render "me"
  end

private

  def find_user
    @user  = User.where("username = ?", params[:username]).first
    @items = Item.where({:user_id => @user.id})
    @size  = @items.size
    redirect_to root_path if @user.nil?
  end

end
