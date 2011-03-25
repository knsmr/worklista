atom_feed do |feed|
  feed.title("Worklista - #{@user.name}")
  feed.updated(@items.first.created_at)

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
