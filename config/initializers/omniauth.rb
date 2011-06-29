Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'app_id', 'app_secret'
  provider :facebook, 'app_id', 'app_secret', :scope => ''
end
