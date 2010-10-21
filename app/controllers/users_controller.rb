class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by_username(params[:username])
  end

end
