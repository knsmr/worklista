class UsersController < ApplicationController
  PAGINATION = 12
  before_filter :find_user, :except => [:index]

  def index
    @users = User.all
  end

  def tag
    @items = @user.items.order("published_at").reverse.find_all do |i|
      i.tag_names.split(" ").include?(params[:tag])
    end.paginate :page => params[:page], :per_page => PAGINATION

    @select = :recent
    render "me"
  end
  
  def show
    @items = @user.items.order("published_at").reverse.paginate :page => params[:page], :per_page => PAGINATION

    @select = :recent
    render "me"
  end

  def popular
    @items = @user.items.order("hatena").reverse.paginate :page => params[:page], :per_page => PAGINATION

    @select = :popular
    render "me"
  end

  def pickup
    @items = @user.items.order("published_at").reverse.find_all{|i| i.pick}.paginate :page => params[:page], :per_page => PAGINATION

    @select = :pickup
    render "me"
  end

private

  def find_user
    @user = User.find_by_username(params[:username])
  end

end
