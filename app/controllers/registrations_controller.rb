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
end
