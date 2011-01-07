# To avoid rack-1.2.1/lib/rack/utils.rb:16: warning: regexp match /.../n against to UTF-8 string
# error messages
# http://crimpycode.brennonbortz.com/?p=42
module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end