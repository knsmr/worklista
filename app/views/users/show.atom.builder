atom_feed do |feed|
  @items = @items.all   # convert the AR object to an Array
  feed.title("Worklista - #{@user.name}")
  feed.updated(@items.first.created_at) unless @items.empty?

  @items.each do |item|
    feed.entry(item) do |entry|
      content_body = <<BODY
tags: #{item.tag_names}\n
BODY
      entry.title(item.title)
      entry.content(content_body)
      entry.author do |author|
        author.name(@user.name)
      end
    end
  end
end
