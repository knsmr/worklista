class RegistrationsController < Devise::RegistrationsController
  def create
    if recaptcha_valid?
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash[:error] = "There was an error with the message you read from the image below. Please re-enter."
      redirect_to "/signup"
    end
  end

  def update
    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
    else
      clean_up_passwords(resource)
      flash[:error] = resource.errors.full_messages.join(", ")
    end
    redirect_to after_update_path_for(resource)
  end
end
