class ApplicationController < ActionController::Base
  protect_from_forgery

  # redirect when a user logs in
  def after_sign_in_path_for(resource)
    if resource.is_a?(User) # && resource.can_publish?
      user_recent_path(current_user.username)
    else
      super
    end
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    users_path
  end

  def after_update_path_for(resource)
    user_recent_path(current_user.username)
  end
end
