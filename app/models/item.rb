# -*- coding: utf-8 -*-
require 'open-uri'
require 'timeout'
require 'kconv'
# require 'resolv-replace'

class Item < ActiveRecord::Base
  belongs_to :user
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  validates :url, :format => {:with => URI::regexp(%w(http https))}
  validates_length_of :title, :maximum => 200
  validates_length_of :summary, :maximum => 200

  attr_writer :tag_names
  attr_accessor :doc

  before_create :guess_published_at, :set_title
  after_save :assign_tags

  paginates_per 15

  scope :tagged, lambda {|tag| joins(:tags).merge(Tag.where :name => tag) }

  def load
    valid? && fetch && save!
  end

  def fetch
    Timeout::timeout(8) do
      set_retweet_and_bitly_url
      set_hatena
    end
  end

  def smart_update
    Timeout::timeout(8) do
      hatena_smart_update
      set_retweet_and_bitly_url
    end
    save!
  end

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end

  def doc
    @doc ||= set_encoding(open(url, "r:ASCII-8BIT").read)
  end

  def toggle_pick_if_the_number_of_picks_doesnt_exceed_the_limit
    if self.pick == false
      if number_of_picks >= 10
        return false
      else
        self.pick = true
      end
    else
      self.pick = false
    end
    self.save!
  end

  def url_normalize
    if self.url !~ /^http/i
      self.url = "http://" + self.url
    end
    url.sub!(/^(http:\/\/www\.amazon\.co\.jp\/).+\/(dp\/[0-9A-Z]+).*/, '\1\2')
    url.sub!(/^(http:\/\/www\.amazon\.co\.jp\/)gp\/product\/([0-9A-Z]+).*/, '\1dp/\2')
    url.sub!(/^(https?:\/\/twitter\.com\/)#\!\/(.+)/, '\1\2')
  end

private

  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/[\s,]+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end

  def guess_published_at
    self.published_at = 
      case doc
      when /(20\d{2}\/[01]?\d\/[0123]?\d)/
        Date.strptime($1, "%Y/%m/%d")
      when /(20\d{2}年[01]?\d月[0123]?\d日)/
        Date.strptime($1, "%Y年%m月%d日")
      when /(20\d{2}-[01]?\d-[0123]?\d)/
        Date.strptime($1, "%Y-%m-%d")
      when /(20\d{2}\.[01]?\d\.[0123]?\d)/
        Date.strptime($1, "%Y.%m.%d")
      else
        Date.today
      end
    if self.published_at > Date.today
      self.published_at = Date.today
    end
  end

  def set_title
    self.title = url
    begin
      doc.match(/<title[^>]*>([^<]+)<\/title>/i) do |m|
        self.title = 
          if m.size == 2
            m[1].encode("utf-8")
              .gsub(/\n/,'')
              .gsub(/&quot;/,'\'')
              .gsub(/&raquo;/,'»')
              .gsub(/&laquo;/,'«')
              .gsub(/&lsquo;/,'‘')
              .gsub(/&rsquo;/,'’')
          end
      end
    rescue => e
      puts e.message  
    end
  end

  def retrieve_hatena
    hatena_api = "http://api.b.st-hatena.com/entry.count?url="
    num = open(hatena_api+url).read
    num = 0 if num == ""
    num.to_i
  end

  def set_hatena
    self.hatena = retrieve_hatena
  end

  def hatena_smart_update
    num = retrieve_hatena
    if num <= self.hatena * 1.05 then
      # reduce the api access more eagerly when the number of
      # bookmarks isn't growing at all
      delay_rate = num == self.hatena ? 8:2
      current_interval = self.interval
      self.interval = current_interval * delay_rate unless current_interval > 2000000000
    end
    self.hatena = num
  end

  def set_retweet_and_bitly_url
    action = self.url !~ /http:\/\/bit\.ly/ ? :shorten : :expand
    bitly = BITLY.__send__(action, self.url)
    self.url       = bitly.long_url
    self.bitly_url = bitly.short_url
    self.retweet   = bitly.global_clicks
  end

  def set_encoding(html)
    enc = 
      if html =~ /meta.+charset[ =]+[\"\']?([^>[\"\']]+)/i ||
        html =~ /xml.+encoding[ =]+[\"\']?([^>[\"\']]+)/i
        $1
      else
        Kconv.guess(html).to_s
      end
    # to handle the obsolete charset name, which should've been extinct...
    enc = "Shift_JIS" if enc.downcase == "x-sjis" 
    enc = "UTF-8" if !Encoding.name_list.map(&:upcase).include?(enc.upcase)
    
    html.force_encoding(enc)
    html.encode("UTF-16BE",
                :invalid => :replace,
                :undef => :replace,
                :replace => '.').encode("UTF-8")
  end

  def number_of_picks
    user_id = self.user_id
    Item.where(:user_id => user_id, :pick => true).size
  end
end
