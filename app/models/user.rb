class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  attr_accessible :email, :username, :name, :title, :twitter_id, \
  :description, :website, :password, :password_confirmation, :remember_me,\
  :photo

  has_attached_file :photo,
                    :styles => { :medium => "240x240", :thumb => "80x80"}, 
                    :default_url => "/images/missing-:style.png"
#                    :path => "public/profile_photo/:id/:style/:filename"
 
end

