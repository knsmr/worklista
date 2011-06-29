class User < ActiveRecord::Base
  has_many :items, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  attr_accessible :email, :username, :name, :title, :twitter_id, \
  :description, :website, :password, :password_confirmation, :remember_me,\
  :photo, :invite_code, :remote_photo_url, :provider, :uid
  attr_accessor :invite_code

  paginates_per 8

  # Validations

  validates_length_of :name, :within => 3..30, :allow_nil => true
  validates_uniqueness_of :username
  validates_length_of :username,    :within  => 3..24
  validates_format_of :username,    :with    => /\A[_a-zA-Z0-9]+\Z/
  validates_format_of :twitter_id,  :with    => /\A[_a-zA-Z0-9]+\Z/, :allow_nil => true, :allow_blank => true
  validates :website, :format => {:with => URI::regexp(%w(http https))}, :allow_nil => true, :allow_blank => true
  validates_length_of :description, :maximum => 160

  # Plugins

  has_attached_file :photo,
                    :styles => { :medium => "240x240", :thumb => "80x80",
                                 :original => "300x300"}, 
                    :default_url => "/images/missing-:style.png"
  validates_attachment_size :photo, :less_than => 1.megabytes

  # Override login key to use username OR email (for devise)

  def self.find_for_database_authentication(conditions)
    value = conditions[authentication_keys.first]
    u = where(["username = :value OR email = :value", { :value => value }]).first
    u.provider ? nil:u 
  end

  # to allow users to edit their accout without providing a password

  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end 

  def self.auth_new(auth)
    info = auth['user_info']
    nickname = info['nickname'].gsub(/\./,'') || info['name'].gsub(/\. /,'')
    username = User.available_name(nickname)
    remote_photo_url = info['image']
    case auth['provider']
    when "twitter"
      description      = info['description']
      twitter_id       = info['nickname']
      website          = info['urls']['Website']
    when "facebook"
      description      = ''
      twitter_id       = ''
      website          = info['urls']['Website'] || info['urls']['Facebook']
    end
    user = User.new(:name => info['name'],
                    :username => username,
                    # dirty password and email strings to comply with devise
                    :password => "hogehoge",
                    :email => username + Time.now.strftime("%Y%m%d%H%M%S") + "@worklista.com",
                    :description => description,
                    :remote_photo_url => remote_photo_url,
                    :twitter_id => twitter_id,
                    :website => website,
                    :provider => auth['provider'],
                    :uid => auth['uid'])
    user.normalize_photo_url
    user
  end

  def normalize_photo_url
    case self.provider
    when "twitter"
      self.remote_photo_url = self.remote_photo_url.gsub(/_normal/,'')
    when "facebook"
      url = URI.parse(self.remote_photo_url.gsub(/\?type.+/,''))
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port){|http| http.request(req)}
      self.remote_photo_url = res.response['location'].gsub(/_q/,'')
    end
  end

  def self.available_name(nickname)
    suffix = false
    unless User.where(:username => nickname).first
      nickname
    else
      # need to give users better UI to change the temporal
      # username when collision occured.
      suffix = 1
      new_name = nickname + suffix.to_s
      while User.where(:username => new_name).first
        suffix = suffix + 1
        new_name = nickname + suffix.to_s
      end
      new_name
    end
  end
end
