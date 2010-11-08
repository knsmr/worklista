class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by_username(params[:username])
  end

  def me
    if user_signed_in?
      @user = current_user
      @items = @user.items.paginate :page => params[:page], :per_page => 10
      render "me"
    else
      redirect_to users_path
#      @users = User.all
#      render "index"
    end
  end

end
