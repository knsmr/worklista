require 'open-uri'
require 'timeout'
# require 'resolv-replace'

class Item < ActiveRecord::Base
  belongs_to :user
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  validates :url, :format => {:with => URI::regexp(%w(http https))}

  attr_writer :tag_names
  attr_accessor :doc

  before_create :guess_published_at, :set_title
  after_save :assign_tags
  
  def load
    valid? && fetch && save!
  end

  def fetch
    Timeout::timeout(8) do
      set_hatena
      set_retweet_and_bitly_url
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
    @doc ||= remove_invalid_sequence(open(url).read)
  end

  private
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end

  def guess_published_at
    self.published_at = if doc =~ /(20\d{2}\/[01]?\d\/[012]?\d)/
      Date.strptime($1, "%Y/%m/%d")
    else
      Date.today
    end
  end

  def set_title
    self.title = url
    doc.match(/<title>([^<]+)<\/title>/) do |m|
      if m.size == 2
        title = m[1]
        self.title = remove_invalid_sequence(title)
      end
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
    if num <= self.hatena * 1.1 then
      current_interval = self.interval
      self.interval = current_interval * 2 unless current_interval > 2000000000
    end
    self.hatena = num
  end

  def set_retweet_and_bitly_url
    bitly = BITLY.shorten(self.url)
    self.bitly_url = bitly.short_url
    self.retweet   = bitly.global_clicks
  end

  def remove_invalid_sequence(str)
    str.encode("UTF-16BE",
               :invalid => :replace,
               :undef => :replace,
               :replace => '?').encode("UTF-8")
  end
end

