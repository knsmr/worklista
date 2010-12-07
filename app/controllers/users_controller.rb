class UsersController < ApplicationController
  PAGINATION = 12

  def index
    @users = User.all
  end

  def tag
    @user = User.find_by_username(params[:username])
    @items = @user.items.order("published_at").reverse.find_all do |i|
      i.tag_names.split(" ").include?(params[:tag])
    end.paginate :page => params[:page], :per_page => PAGINATION

    @select = :recent
    render "me"
  end
  
  def show
    @user = User.find_by_username(params[:username])
    @items = @user.items.order("published_at").reverse.paginate :page => params[:page], :per_page => PAGINATION

    @select = :recent
    render "me"
  end

  def popular
    @user = User.find_by_username(params[:username])
    @items = @user.items.order("hatena").reverse.paginate :page => params[:page], :per_page => PAGINATION

    @select = :popular
    render "me"
  end

  def pickup
    @user = User.find_by_username(params[:username])
    @items = @user.items.order("published_at").reverse.find_all{|i| i.pick}.paginate :page => params[:page], :per_page => PAGINATION

    @select = :pickup
    render "me"
  end

end
