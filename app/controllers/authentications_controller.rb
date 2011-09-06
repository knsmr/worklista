require 'open-uri'

class AuthenticationsController < ApplicationController
  attr_accessor :auth

  def callback_handler
    @auth = request.env['omniauth.auth']
    if already_signedin_using_oauth?
      update_photo
    else
      find_or_create_user_with_auth
    end
  end

  def find_or_create_user_with_auth
    user = User.where(:provider => @auth['provider'],
                      :uid      => @auth['uid']).first
    if user
      sign_in user
      flash[:notice] = "Welcome #{user.username}!"
      redirect_to "/users/#{user.username}"
    else
      user = User.auth_new(@auth)
      File.open(cache_path(user), "wb") do |f|
        photo = PhotoUrl::Base.generate(user, {:size => :normal})
        f.write(open(photo.path).read)
      end
      logger.info "Stats: confirming registration: #{user.username} via #{user.provider} #{Time.now}"
      render 'users/confirm',
      :locals => { :user => user }
    end
  end

private

  def cache_path(user)
    File.join(Rails.root, 'public', 'images', 'cache', user.provider+user.uid)
  end

  def update_photo
    user = current_user
    user.remote_photo_url = @auth['user_info']['image']
    user.normalize_photo_url
    if user.save
      flash[:notice] = "Updated account info!"
      redirect_to '/account'
    else
      flash[:error] = "Ooops, something went wrong."
    end
  end

  def already_signedin_using_oauth?
    current_user and current_user.provider
  end
end
