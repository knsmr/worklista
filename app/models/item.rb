class Item < ActiveRecord::Base
  belongs_to :user
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  validates :url, :format => { :with => URI::regexp(%w(http https))}

  # let us do the url validation in the contorller

  attr_writer :tag_names
  after_save :assign_tags
  attr_accessor :doc
  before_create :guess_published_at, :set_title
  
  def fetch
    Timeout::timeout(8) do
      @doc = open(url).read
    end
  end

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
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
    self.published_at = if @doc =~ /(20\d{2}\/[01]?\d\/[012]?\d)/
      Date.strptime($1, "%Y/%m/%d")
    else
      Date.today
    end
  end

  def set_title
    self.title = url
    @doc.match(/<title>([^<]+)<\/title>/) do |m|
      if m.size == 2
        title = m[1]
        self.title = NKF.nkf("--utf8", title)
      end
    end
  end
end
