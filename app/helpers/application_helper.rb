require 'uri'

module ApplicationHelper
  include Rack::Recaptcha::Helpers

  ICON_SIZE = {small:"24x24", normal:"73x73", big:"240x240"}

  def title(page_title)
    content_for(:title) { page_title }
  end

  def link_to_hatena(url)
    base_url = "http://b.hatena.ne.jp/entry/"
    if url =~ /^(http:\/\/)(.+)/
      target = $2
    else
      target = ""
    end
    base_url + target 
  end
  
  def photo_tag(user, options = {:size => :normal})
    twitter_icon_path = lambda do |path, suffix|
      u     = URI.parse(path)
      ext   = File.extname(u.path)
      path.gsub(ext, suffix + ext)
    end

    icon_size = ICON_SIZE[options[:size]]
    raise "Invalid size option for photo_url" if icon_size.nil?
 
    photo_url = 
      if user.remote_photo_url
        case options[:size]
        when :small
          twitter_icon_path.call(user.remote_photo_url, "_normal")
        when :normal
          twitter_icon_path.call(user.remote_photo_url, "_bigger")
        when :big
          user.remote_photo_url
        else
          raise "Invalid size option for photo_url"
        end
      else
        case options[:size]
        when :small
          user.photo.url(:thumb)
        when :normal
          user.photo.url(:thumb)
        when :big
          user.photo.url(:medium)
        else
          raise "Invalid size option for photo_url"
        end
      end
    image_tag photo_url, :size => icon_size
  end

  def truncstr(str, size)
    # Considering the width of the displayed string since a Japanese
    # character takes twice the width as alphanumeric.
    return str if str.size <= size
    truncated = str[0, size]
    non_alphanum = truncated.gsub(/[\w\s\d]/, '')
    extra_space = (truncated.size - non_alphanum.size) / 2
    if str.size <= size + extra_space
      str
    else
      str[0,size + extra_space] + "..."
    end
  end

  # We need this for atom_feed since an item doesn't have its
  # correspoding show page
  def item_url(item)
    item.url
  end

  def feed_tag
    url_options = Rails.env.production? ? {:host => "worklista.com"} : {:host => "localhost:3000"}
    content_for(:feed) { auto_discovery_link_tag(:atom, user_path(params[:username]) + ".atom", url_options) }
  end

  def oauthed?
    !current_user.provider.nil?
  end
end
