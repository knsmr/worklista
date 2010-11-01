class User < ActiveRecord::Base
  has_many :items, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  attr_accessible :email, :username, :name, :title, :twitter_id, \
  :description, :website, :password, :password_confirmation, :remember_me,\
  :photo

  validates_uniqueness_of :username
  validates_presence_of :name

  # Override login key to use username OR email
  def self.find_for_database_authentication(conditions)
    value = conditions[authentication_keys.first]
    where(["username = :value OR email = :value", { :value => value }]).first
  end

  has_attached_file :photo,
                    :styles => { :medium => "240x240", :thumb => "80x80"}, 
                    :default_url => "/images/missing-:style.png"

  validates_attachment_size :photo, :less_than => 2.megabytes

end
