class ItemsController < ApplicationController

  conf = APP_CONFIG["bitly"]
  @@bitly = Bitly.new(conf["username"], conf["apikey"])

  def create
    @user = User.find(params[:user_id])
    @item = @user.items.create(params[:item])

    if @item.url !~ /^(#{URI::regexp(%w(http https))})$/ then
      flash[:notice] = "Invalid URL!!"
      redirect_to me_path
      return
    end

    populate @item
    if @item.save
      flash[:notice] = "Successfully created an item."
      redirect_to me_path
    else
      render :action => 'new'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed an item."
    redirect_to me_path
  end

  private

  def populate(item)
    populate_title(item)
    populate_hatena(item)
    populate_retweet(item)
  end
  
  def populate_title(item)
    doc = open(item.url).read
    item.title = item.url
    doc.match(/<title>([^<]+)<\/title>/) do |m|
      if m.size == 2 then 
        title = m[1]
        item.title = NKF.nkf("--utf8", title)
      end
    end
  end
  
  def populate_hatena(item)
    hatena_api = "http://api.b.st-hatena.com/entry.count?url="
    url = item.url
    num = open(hatena_api+url).read
    num = 0 if num == ""
    item.hatena = num
  end

  def populate_retweet(item)
    url = @@bitly.shorten(item.url)
    item.bitly_url = url.short_url
    item.retweet   = url.global_clicks
  end

end
