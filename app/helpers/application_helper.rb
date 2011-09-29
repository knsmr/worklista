# -*- coding: utf-8 -*-
require 'photo_url.rb'

module ApplicationHelper
  include Rack::Recaptcha::Helpers

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

  def social_buttons(options = {})
    return unless options[:url]
    hatena = <<-EOSTR
     <a href=\"http://b.hatena.ne.jp/entry/#{options[:url]}\" class=\"hatena-bookmark-button\" data-hatena-bookmark-title=\"#{options[:title]}\" data-hatena-bookmark-layout=\"standard\" title=\"このエントリーをはてなブックマークに追加\"><img src="http://b.st-hatena.com/images/entry-button/button-only.gif" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a>
    EOSTR
    twitter = <<-EOSTR
      <a href=\"https://twitter.com/share\" class=\"twitter-share-button\" data-url=\"#{options[:url]}\" data-text=\"#{options[:title]}\" data-count=\"horizontal\" data-via=\"#{options[:user].twitter_id}\">Tweet</a>
    EOSTR
    facebook = <<-EOSTR
      <div class=\"fb-like\" data-href=\"#{options[:url]}\" data-send=\"false\" data-layout=\"button_count\" data-width=\"110\" data-show-faces=\"false\" data-colorscheme=\"light\"></div>
    EOSTR
    hatena + twitter + facebook
  end

  def photo_tag(user, options = {:size => :normal})
    photo = PhotoUrl::Base.generate(user, options)
    size  = photo.icon_size
    raise "Invalid size option for photo_tag" if size.nil?
    image_tag photo.path, :size => size
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
