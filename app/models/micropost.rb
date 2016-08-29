class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  
  # has_many :user_favorite_microposts
  # has_many :favorite_microposts, through: :user_favorite_microposts, source: :micropost

  # has_many :user_favorite_microposts
  # has_many :favorite_users, through: :user_favorite_microposts, source: :user
 
end
