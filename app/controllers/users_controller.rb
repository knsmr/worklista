class UsersController < ApplicationController
  before_filter :find_user, :except => [:index]

  def index
    @users = User.all
  end

  def tag
    @items = @items.select do |i|
      i.tag_names.split(" ").include?(params[:tag])
    end
    # quick fix for the time being since it's not a relation
    @items.instance_eval <<-EVAL
      def current_page
        #{params[:page] || 1}
      end
      def num_pages
        self.size / limit_value + 1
      end
      def limit_value
        20
      end
    EVAL

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
