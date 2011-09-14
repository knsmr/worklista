require 'open-uri'

class UsersController < ApplicationController
  before_filter :find_user, :except => [:index, :create]

  def index
    @users = User.order("last_item_updated_at DESC").page params[:page]
  end

  def tag
    @tag = params[:tag]
    @items = @items.tagged(@tag).order("published_at DESC").page params[:page]
    if (@size = @items.size).zero?
      flash[:error] = "Tag you specified: #{params[:tag]} does not exist."
      redirect_to user_recent_path
    else
      @select = :recent
      render "me"
    end
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

  def create
    @user = User.new(params[:user])
    if @user.save
      logger.info "Stats: registered a new user  : #{@user.username} via #{@user.provider} #{Time.now}"
      flash[:notice] = "Welcome #{@user.username} ! Any changes here? Click on Me button to start adding your items!"
      sign_in @user
      redirect_to '/account'
    else
      flash[:error] = "Something went wrong with Twitter login..."
      redirect_to '/'
    end
  end

  def export_xml
    @list = @items.map do |i|
      {title: i.title,
        url: i.url,
        tags: i.tag_names,
        summary: i.summary,
        date: i.published_at}
    end
    render :xml => @list.to_xml
  end

private

  def find_user
    @user  = User.where("username = ?", params[:username]).first
    if @user.nil?
      flash[:error] = "The username you specified, #{params[:username]} does not exist."
      redirect_to users_path
    else
      @items = Item.where({:user_id => @user.id})
      @size  = @items.size
    end
  end

end
