module ApplicationHelper

  def link_to_hatena(url)
    base_url = "http://b.hatena.ne.jp/entry/"
    if url =~ /^(http:\/\/)(.+)/
      target = $2
    else
      target = ""
    end
    base_url + target 
   end

end
