class User < ActiveRecord::Base
  has_many :microposts
  validates :name_is_present
  validates :email_is_present
end
