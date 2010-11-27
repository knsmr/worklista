class ApplicationController < ActionController::Base
  protect_from_forgery

  # redirect when logged-in overriding a devise method. 
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    if user_signed_in?
      redirect_to user_recent_path(current_user.username)
    else
      redirect_to users_path
    end
  end


private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    users_path
  end
end
