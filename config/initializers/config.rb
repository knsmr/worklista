APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

require 'bitly'
Bitly.use_api_version_3
conf = APP_CONFIG["bitly"]
BITLY = Bitly.new(conf["username"], conf["apikey"])