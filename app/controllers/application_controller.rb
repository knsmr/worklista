class ApplicationController < ActionController::Base
  protect_from_forgery

  # redirect when logged-in overriding a devise method. 
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    redirect_to user_recent_path(current_user.username)
  end
end
