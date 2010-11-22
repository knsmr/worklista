class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by_username(params[:username])
    @items = @user.items
                  .order("published_at").reverse
                  .paginate :page => params[:page], :per_page => 10
    render "me"
  end

  def popular
    @user = User.find_by_username(params[:username])
    @items = @user.items
                  .order("hatena").reverse
                  .paginate :page => params[:page], :per_page => 10
    render "me"
  end

  def pickup
    @user = User.find_by_username(params[:username])
    @items = @user.items
                  .find_all{|i| i.pick}
                  .paginate :page => params[:page], :per_page => 10
    render "me"
  end

  def me
    if user_signed_in?
      @user = current_user
      @items = @user.items
                    .order("published_at").reverse
                    .paginate :page => params[:page], :per_page => 10

      render "me"
    else
      redirect_to users_path
    end
  end
end
