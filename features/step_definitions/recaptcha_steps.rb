# Redefine validate_captcha for here
class ApplicationController
  def recaptcha_valid?
    return true
  end  
end

Given /^I fill in the correct captcha$/ do
end
