Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'app_id', 'app_secret'
  provider :facebook, 'app_id', 'app_secret', :scope => ''
  if Rails.env.production?
    provider :facebook, 'app_id', 'app_secret', {:scope => '', :client_options => {:ssl => { :ca_file => 'you_path_to_ca_certificaets'}}}
  else
    provider :facebook, 'app_id', 'app_secret', :scope => ''
  end
end

if Rails.env.production?
  OmniAuth.config.full_host = 'https://worklista.com'
end
