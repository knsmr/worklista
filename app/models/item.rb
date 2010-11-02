class Item < ActiveRecord::Base
  belongs_to :user
  # let us do the url validation in the contorller
end
