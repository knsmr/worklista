class User < ActiveRecord::Base
  has_many :items, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  attr_accessible :email, :username, :name, :title, :twitter_id, \
  :description, :website, :password, :password_confirmation, :remember_me,\
  :photo, :invite_code
  attr_accessor :invite_code

  # Validations

  validates_length_of :name, :within => 3..30, :allow_nil => true
  validates_uniqueness_of :username
  validates_length_of :username,    :within  => 3..24
  validates_format_of :username,    :with    => /\A[_a-zA-Z0-9]+\Z/
  validates_format_of :twitter_id,  :with    => /\A[_a-zA-Z0-9]+\Z/, :allow_nil => true, :allow_blank => true
  validates_length_of :description, :maximum => 120

  # Plugins

  has_attached_file :photo,
                    :styles => { :medium => "240x240", :thumb => "80x80",
                                 :original => "300x300"}, 
                    :default_url => "/images/missing-:style.png"
  validates_attachment_size :photo, :less_than => 1.megabytes

  # Override login key to use username OR email

  def self.find_for_database_authentication(conditions)
    value = conditions[authentication_keys.first]
    where(["username = :value OR email = :value", { :value => value }]).first
  end

  # to allow users to edit their accout without providing a password

  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end 
end
