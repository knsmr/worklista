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

  # We need this for atom_feed since an item doesn't have its
  # correspoding show page
  def item_url(item)
    item.url
  end

  def feed_tag
    url_options = Rails.env.production? ? {:host => "worklista.com"} : {:host => "localhost:3000"}
    content_for(:feed) { auto_discovery_link_tag(:atom, url_options) }
  end
end
