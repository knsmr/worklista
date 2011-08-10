class ErrorsController < ApplicationController
  def routing
    @user = User.where(:username => params[:a]).first
    if @user
      redirect_to user_recent_path(@user.username)
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end
end
